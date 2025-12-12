package com.tom.paperless.data


import com.google.firebase.firestore.FirebaseFirestore
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.dto.AssetUserDto
import com.tom.paperless.data.repositories.dto.AssignmentDto
import com.tom.paperless.data.repositories.dto.NfcTaggableDto
import com.tom.paperless.data.repositories.mappers.toAssetUserDomain
import com.tom.paperless.data.repositories.mappers.toDomain
import com.tom.paperless.data.repositories.mappers.toDto
import com.tom.paperless.data.repositories.mappers.toKeyRingDomain
import com.tom.paperless.data.repositories.mappers.toToolDomain
import com.tom.paperless.data.repositories.mappers.toVehicleDomain
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagType
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.tasks.await
import kotlinx.datetime.Clock
import kotlin.uuid.Uuid

class FirebaseAssignmentRepository(
    private val db: FirebaseFirestore
) : AssignmentRepository {

    private val collection = db.collection("assignments")

    override suspend fun add(assignment: Assignment): Assignment {
        TODO("Not yet implemented")
    }

    override suspend fun getAll(): List<Assignment> {
        TODO("Not yet implemented")
    }

    override suspend fun getById(id: Uuid): Assignment? {
        TODO("Not yet implemented")
    }

    override suspend fun getByAsset(taggableId: Uuid): List<Assignment> {
        TODO("Not yet implemented")
    }

    override suspend fun getByEmployee(assetUserId: Uuid): List<Assignment> {
        TODO("Not yet implemented")
    }

    override suspend fun update(assignment: Assignment): Assignment? {
        TODO("Not yet implemented")
    }

    override suspend fun delete(id: Uuid): Boolean {
        TODO("Not yet implemented")
    }
}
