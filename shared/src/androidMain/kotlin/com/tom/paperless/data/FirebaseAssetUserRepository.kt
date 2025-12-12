package com.tom.paperless.data

import com.google.firebase.firestore.FirebaseFirestore
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.data.repositories.dto.AssetUserDto
import com.tom.paperless.data.repositories.mappers.toDomain
import com.tom.paperless.data.repositories.mappers.toDto
import com.tom.paperless.domain.models.AssetUser
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.tasks.await
import kotlin.uuid.Uuid

class FirebaseAssetUserRepository(
    private val db: FirebaseFirestore
) : AssetUserRepository {

    private val collection = db.collection("assetUsers")

    override suspend fun getAll(): List<AssetUser> {
        val snap = collection.get().await()
        return snap.documents.mapNotNull {
            it.toObject(AssetUserDto::class.java)?.toDomain()
        }
    }

    override suspend fun getById(id: Uuid): AssetUser? {
        val doc = collection.document(id.toString()).get().await()
        return doc.toObject(AssetUserDto::class.java)?.toDomain()
    }

    override suspend fun add(assetUser: AssetUser): AssetUser {
        collection.document(assetUser.id.toString())
            .set(assetUser.toDto())
            .await()
        return assetUser
    }

    override suspend fun update(assetUser: AssetUser): AssetUser {
        collection.document(assetUser.id.toString())
            .set(assetUser.toDto())
            .await()
        return assetUser
    }

    override suspend fun delete(id: Uuid): Boolean {
        collection.document(id.toString()).delete().await()
        return true
    }
}
