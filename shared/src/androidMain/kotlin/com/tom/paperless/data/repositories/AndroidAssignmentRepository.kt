package com.tom.paperless.data.repositories

import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.QuerySnapshot
import com.tom.paperless.domain.models.Assignment
import kotlinx.coroutines.tasks.await
import kotlin.uuid.Uuid

class AndroidAssignmentRepository(
    private val db: FirebaseFirestore
) : AssignmentRepository {
    private var registration: ListenerRegistration? = null
    private val collection = db.collection("assignments")

    override suspend fun add(assignment: Assignment): Assignment {
        collection
            .document(assignment.id.toString())
            .set(assignment)
            .await()

        return assignment
    }

    override suspend fun getAll(): List<Assignment> {
        return collection
            .get()
            .await()
            .documents
            .mapNotNull { it.toObject(Assignment::class.java) }
    }

    override suspend fun getById(id: Uuid): Assignment? {
        return collection
            .document(id.toString())
            .get()
            .await()
            .toObject(Assignment::class.java)
    }

    override suspend fun getByAsset(taggableId: Uuid): List<Assignment> {
        return collection
            .whereEqualTo("taggableId", taggableId)
            .get()
            .await()
            .documents
            .mapNotNull { it.toObject(Assignment::class.java) }
    }

    override suspend fun getByEmployee(assetUserId: Uuid): List<Assignment> {
        return collection
            .whereEqualTo("employeeId", assetUserId)
            .get()
            .await()
            .documents
            .mapNotNull { it.toObject(Assignment::class.java) }
    }

    override suspend fun update(assignment: Assignment): Assignment? {
        collection
            .document(assignment.id.toString())
            .set(assignment)
            .await()

        return assignment
    }

    override suspend fun delete(id: Uuid): Boolean {
        collection
            .document(id.toString())
            .delete()
            .await()

        return true
    }

    override fun observeAll(onChange: (List<Assignment>) -> Unit) {
        registration?.remove()

        registration = collection.addSnapshotListener { snapshot: QuerySnapshot?, error ->
            if (snapshot == null || error != null) return@addSnapshotListener

            val assignments = snapshot.documents.mapNotNull { doc ->
                doc.toObject(Assignment::class.java)
            }

            onChange(assignments)
        }
    }

    override fun observeByAsset(
        taggableId: Uuid,
        onChange: (List<Assignment>) -> Unit
    ) {
        TODO("Not yet implemented")
    }


    override fun stopObserving() {
        registration?.remove()
        registration = null
    }
}