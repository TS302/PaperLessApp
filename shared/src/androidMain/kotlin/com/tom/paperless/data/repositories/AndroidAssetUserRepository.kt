package com.tom.paperless.data.repositories

import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.QuerySnapshot
import com.tom.paperless.data.repositories.dto.AssetUserDto
import com.tom.paperless.data.repositories.mappers.toDomain
import com.tom.paperless.data.repositories.mappers.toDto
import com.tom.paperless.domain.models.AssetUser
import kotlinx.coroutines.tasks.await
import kotlin.uuid.Uuid

class AndroidAssetUserRepository(
    private val db: FirebaseFirestore
) : AssetUserRepository {
    private var registration: ListenerRegistration? = null
    private val collection = db.collection("assetUsers")
    
    override suspend fun getAll(): List<AssetUser> {
        val snap = collection.get().await()
        return snap.documents.mapNotNull {
            it.toObject(AssetUserDto::class.java)?.toDomain()
        }
    }
    override suspend fun add(assetUser: AssetUser): AssetUser {
        collection.document(assetUser.id.toString())
            .set(assetUser.toDto())
            .await()
        return assetUser
    }

//    override suspend fun getById(id: Uuid): AssetUser? {
//        val doc = collection.document(id.toString()).get().await()
//        return doc.toObject(AssetUserDto::class.java)?.toDomain()
//    }

    //    override suspend fun delete(id: Uuid): Boolean {
//        collection.document(id.toString()).delete().await()
//        return true
//    }

    //--HIER WEITER!!!
    override suspend fun getById(id: Uuid): AssetUser? = getById(id.toString())
    override suspend fun delete(id: Uuid): Boolean = delete(id.toString())

    override suspend fun getById(id: String): AssetUser? {
        val doc = collection.document(id).get().await()
        return doc.toObject(AssetUserDto::class.java)?.toDomain()
    }

    override suspend fun delete(id: String): Boolean {
        collection.document(id).delete().await()
        return true
    }

    override suspend fun update(assetUser: AssetUser): AssetUser {
        collection.document(assetUser.id.toString())
            .set(assetUser.toDto())
            .await()
        return assetUser
    }

    override fun observeAll(onChange: (List<AssetUser>) -> Unit) {
        registration?.remove()

        registration = collection.addSnapshotListener { snapshot: QuerySnapshot?, error ->
            if (snapshot == null || error != null) return@addSnapshotListener

            val users = snapshot.documents.mapNotNull { doc ->
                doc.toObject(AssetUserDto::class.java)?.toDomain()
            }
            onChange(users)
        }
    }

    override fun stopObserving() {
        registration?.remove()
        registration = null
    }
}