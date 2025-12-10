package com.tom.paperless.data

import com.google.firebase.firestore.FirebaseFirestore
import com.tom.paperless.data.repositories.NfcTaggableRepository
import kotlinx.coroutines.flow.StateFlow
import com.tom.paperless.domain.models.NfcTaggable
import kotlinx.coroutines.flow.callbackFlow
import com.tom.paperless.data.repositories.dto.NfcTaggableDto
import com.tom.paperless.data.repositories.mappers.toAssetUserDomain
import com.tom.paperless.data.repositories.mappers.toDto
import com.tom.paperless.data.repositories.mappers.toKeyRingDomain
import com.tom.paperless.data.repositories.mappers.toToolDomain
import com.tom.paperless.data.repositories.mappers.toVehicleDomain
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.tasks.await
import kotlin.uuid.Uuid

class FirebaseNfcTaggableRepository(
    private val db: FirebaseFirestore
) : NfcTaggableRepository {

    private val collection = db.collection("nfcItems")

    override fun observeAll(): StateFlow<List<NfcTaggable>> =
        callbackFlow {
            val listener = collection.addSnapshotListener { snapshot, error ->
                if (error != null) {
                    close(error)
                    return@addSnapshotListener
                }

                val items = snapshot?.documents?.mapNotNull { doc ->

                    val dto = doc.toObject(NfcTaggableDto::class.java) ?: return@mapNotNull null

                    when (TagType.valueOf(dto.tagType)) {
                        TagType.Tool -> dto.toToolDomain()
                        TagType.Vehicle -> dto.toVehicleDomain()
                        TagType.Key -> dto.toKeyRingDomain()
                        TagType.AssetUser -> dto.toAssetUserDomain()
                    }
                } ?: emptyList()

                trySend(items)
            }
            awaitClose { listener.remove() }
        }.stateIn(CoroutineScope(Dispatchers.Default), SharingStarted.Eagerly, emptyList())

    override suspend fun getAll(): List<NfcTaggable> {
        val snap = collection.get().await()
        return snap.documents.mapNotNull { doc ->

            val dto = doc.toObject(NfcTaggableDto::class.java) ?: return@mapNotNull null

            when (TagType.valueOf(dto.tagType)) {
                TagType.Tool -> dto.toToolDomain()
                TagType.Vehicle -> dto.toVehicleDomain()
                TagType.Key -> dto.toKeyRingDomain()
                TagType.AssetUser -> dto.toAssetUserDomain()
            }
        }
    }

    override suspend fun getById(id: Uuid): NfcTaggable? {
        val doc = collection.document(id.toString()).get().await()

        val dto = doc.toObject(NfcTaggableDto::class.java) ?: return null

        return when (TagType.valueOf(dto.tagType)) {
            TagType.Tool -> dto.toToolDomain()
            TagType.Vehicle -> dto.toVehicleDomain()
            TagType.Key -> dto.toKeyRingDomain()
            TagType.AssetUser -> dto.toAssetUserDomain()
        }
    }

    override suspend fun add(itemToAdd: NfcTaggable): NfcTaggable {
        val dto = itemToAdd.toDto()
        collection.document(itemToAdd.id.toString()).set(dto).await()
        return itemToAdd
    }

    override suspend fun update(itemToUpdate: NfcTaggable): NfcTaggable? {
        val dto = itemToUpdate.toDto()
        collection.document(itemToUpdate.id.toString()).set(dto).await()
        return itemToUpdate
    }

    override suspend fun updateStatus(id: Uuid, status: TagStatus): NfcTaggable {
        val existing = getById(id) ?: error("not found")
        val updated = when (existing) {
            is Tool -> existing.copy(tagStatus = status)
            is Vehicle -> existing.copy(tagStatus = status)
            is KeyRing -> existing.copy(tagStatus = status)
            is AssetUser -> existing.copy(tagStatus = status)
        }
        update(updated)
        return updated
    }

    override suspend fun delete(id: Uuid): Boolean {
        return try {
            collection.document(id.toString()).delete().await()
            true
        } catch (_: Exception) {
            false
        }
    }

    override suspend fun getAllByType(type: TagType): List<NfcTaggable> {
        val snapshot = collection
            .whereEqualTo("tagType", type.name)
            .get()
            .await()

        return snapshot.documents.mapNotNull { doc ->
            val dto = doc.toObject(NfcTaggableDto::class.java) ?: return@mapNotNull null

            when (TagType.valueOf(dto.tagType)) {
                TagType.Tool -> dto.toToolDomain()
                TagType.Vehicle -> dto.toVehicleDomain()
                TagType.Key -> dto.toKeyRingDomain()
                TagType.AssetUser -> dto.toAssetUserDomain()
            }
        }
    }


    override fun observeByType(type: TagType): StateFlow<List<NfcTaggable>> =
        callbackFlow {
            val listener = collection
                .whereEqualTo("tagType", type.name)
                .addSnapshotListener { snapshot, error ->
                    if (error != null) {
                        close(error)
                        return@addSnapshotListener
                    }

                    val items = snapshot?.documents?.mapNotNull { doc ->

                        val dto = doc.toObject(NfcTaggableDto::class.java)
                            ?: return@mapNotNull null

                        when (TagType.valueOf(dto.tagType)) {
                            TagType.Tool -> dto.toToolDomain()
                            TagType.Vehicle -> dto.toVehicleDomain()
                            TagType.Key -> dto.toKeyRingDomain()
                            TagType.AssetUser -> dto.toAssetUserDomain()
                        }
                    } ?: emptyList()

                    trySend(items)
                }

            awaitClose { listener.remove() }
        }.stateIn(
            scope = CoroutineScope(Dispatchers.IO),
            started = SharingStarted.Eagerly,
            initialValue = emptyList()
        )

}
