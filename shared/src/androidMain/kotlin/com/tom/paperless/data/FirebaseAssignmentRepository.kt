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

    override fun observeAll(): StateFlow<List<Assignment>> =
        callbackFlow {
            val listener = collection.addSnapshotListener { snapshot, error ->
                if (error != null) {
                    close(error)
                    return@addSnapshotListener
                }

                val assignments = snapshot?.documents
                    ?.mapNotNull { it.toObject(AssignmentDto::class.java)?.toDomain() }
                    ?: emptyList()

                trySend(assignments)
            }
            awaitClose { listener.remove() }
        }.stateIn(
            CoroutineScope(Dispatchers.Default),
            SharingStarted.Eagerly,
            emptyList()
        )

    override fun observeForEmployee(assetUserId: Uuid): StateFlow<List<Assignment>> =
        observeAll().map { it.filter { a -> a.assetUserId == assetUserId && a.until == null } }
            .stateIn(
                CoroutineScope(Dispatchers.Default),
                SharingStarted.Eagerly, emptyList()
            )

    override fun observeForAsset(taggableId: Uuid): StateFlow<List<Assignment>> =
        observeAll()
            .map { list -> list.filter { a -> a.tagId == taggableId && a.until == null } }
            .stateIn(
                CoroutineScope(Dispatchers.Default),
                SharingStarted.Eagerly,
                emptyList()
            )

    //TODO("Zu useCases auslagern")
    override suspend fun currentAssigneeOf(taggableId: Uuid): AssetUser? {
        val open = getOpenAssignment(taggableId) ?: return null

        val userDoc = db.collection("assetUsers")
            .document(open.assetUserId.toString())
            .get()
            .await()

        return userDoc.toObject(AssetUserDto::class.java)?.toDomain()
    }

    //TODO("Zu useCases auslagern")
    override suspend fun lastAssignmentsOf(
        taggableId: Uuid,
        limit: Int
    ): List<Assignment> {

        val snap = collection
            .whereEqualTo("tagId", taggableId.toString())
            .get()
            .await()

        return snap.documents
            .mapNotNull { it.toObject(AssignmentDto::class.java)?.toDomain() }
            .sortedByDescending { it.from }
            .take(limit)
    }

    //TODO("Zu useCases auslagern")
    override suspend fun lastAssigneesOf(
        taggableId: Uuid,
        limit: Int
    ): List<AssetUser> {

        val last = lastAssignmentsOf(taggableId, limit)

        val users = last.mapNotNull { assignment ->
            val userDoc = db.collection("assetUsers")
                .document(assignment.assetUserId.toString())
                .get()
                .await()

            userDoc.toObject(AssetUserDto::class.java)?.toDomain()
        }

        return users
    }

    //TODO("Zu useCases auslagern")
    override suspend fun assetsOf(assetUserId: Uuid): List<NfcTaggable> {

        val snap = collection
            .whereEqualTo("assetUserId", assetUserId.toString())
            .whereEqualTo("until", null)
            .get()
            .await()

        val assignments = snap.documents
            .mapNotNull { it.toObject(AssignmentDto::class.java)?.toDomain() }

        val result = mutableListOf<NfcTaggable>()

        for (a in assignments) {
            val tagDoc = db.collection("nfcItems")
                .document(a.tagId.toString())
                .get()
                .await()

            val dto = tagDoc.toObject(NfcTaggableDto::class.java) ?: continue

            val taggable = when (TagType.valueOf(dto.tagType)) {
                TagType.Tool       -> dto.toToolDomain()
                TagType.Vehicle    -> dto.toVehicleDomain()
                TagType.Key        -> dto.toKeyRingDomain()
                TagType.AssetUser  -> dto.toAssetUserDomain()
            }

            result.add(taggable)
        }

        return result
    }

    //TODO("Zu useCases auslagern")
    override suspend fun assign(taggableId: Uuid, toEmployeeId: Uuid, note: String?): Assignment {
        val now = Clock.System.now()

        val open = getOpenAssignment(taggableId)
        if (open != null) {
            val closed = open.copy(until = now)
            collection.document(closed.id.toString()).set(closed.toDto()).await()
        }

        val newAssignment = Assignment(
            id = Uuid.random(),
            assetUserId = toEmployeeId,
            tagId = taggableId,
            from = now,
            note = note
        )

        collection.document(newAssignment.id.toString())
            .set(newAssignment.toDto()).await()

        return newAssignment
    }

    override suspend fun unassign(taggableId: Uuid): Boolean {
        val open = getOpenAssignment(taggableId) ?: return false
        val updated = open.copy(until = Clock.System.now())
        collection.document(updated.id.toString()).set(updated.toDto()).await()
        return true
    }

    override suspend fun closeAssignment(assignmentId: Uuid): Boolean {
        val doc = collection.document(assignmentId.toString()).get().await()
        val dto = doc.toObject(AssignmentDto::class.java) ?: return false
        val updated = dto.toDomain().copy(until = Clock.System.now())
        collection.document(updated.id.toString()).set(updated.toDto()).await()
        return true
    }

    private suspend fun getOpenAssignment(taggableId: Uuid): Assignment? {
        val snap = collection
            .whereEqualTo("tagId", taggableId.toString())
            .whereEqualTo("until", null)
            .get()
            .await()

        return snap.documents.firstOrNull()
            ?.toObject(AssignmentDto::class.java)
            ?.toDomain()
    }
}
