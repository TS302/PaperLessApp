package com.tom.paperless.data.repositories

import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ListenerRegistration
import com.google.protobuf.LazyStringArrayList.emptyList
import com.tom.paperless.data.repositories.dto.KeyRingDto
import com.tom.paperless.data.repositories.dto.NfcTaggableDto
import com.tom.paperless.data.repositories.dto.ToolDto
import com.tom.paperless.data.repositories.dto.VehicleDto
import com.tom.paperless.data.repositories.mappers.toAssetUserDomain
import com.tom.paperless.data.repositories.mappers.toDto
import com.tom.paperless.data.repositories.mappers.toKeyRingDomain
import com.tom.paperless.data.repositories.mappers.toToolDomain
import com.tom.paperless.data.repositories.mappers.toVehicleDomain
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagType
import kotlinx.coroutines.tasks.await
import kotlin.uuid.Uuid
import com.tom.paperless.data.repositories.mappers.toDomain

class AndroidNfcTaggableRepository(
    private val db: FirebaseFirestore
) : NfcTaggableRepository {

    private val collection = db.collection("nfcItems")
    private val firestore = FirebaseFirestore.getInstance()
    private var listener: ListenerRegistration? = null

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

    override suspend fun delete(id: Uuid): Boolean {
        return try {
            collection.document(id.toString()).delete().await()
            true
        } catch (_: Exception) {
            false
        }
    }


    override fun observeAll(onChange: (List<NfcTaggable>) -> Unit) {

        listener?.remove()

        listener = firestore
            .collection("nfcItems")
            .addSnapshotListener { snapshot, error ->


                if (error != null) {
                    return@addSnapshotListener
                }

                snapshot?.documents?.forEach {
                    println("🔥 doc id=${it.id}, data=${it.data}")
                }

                val items = snapshot?.documents
                    ?.mapNotNull { doc ->
                        val tagType = doc.getString("tagType")
                        println("🔥 mapping doc ${doc.id}, tagType=$tagType")

                        when (tagType) {
                            "Tool" ->
                                doc.toObject(ToolDto::class.java)?.toDomain()
                            "Vehicle" ->
                                doc.toObject(VehicleDto::class.java)?.toDomain()
                            "KeyRing" ->
                                doc.toObject(KeyRingDto::class.java)?.toDomain()
                            else -> null
                        }
                    }
                    ?: emptyList()

                println("🔥 mapped items size = ${items.size}")
                onChange(items as List<NfcTaggable>)
            }
    }
    override fun stopObserving() {
        listener?.remove()
        listener = null
    }
}