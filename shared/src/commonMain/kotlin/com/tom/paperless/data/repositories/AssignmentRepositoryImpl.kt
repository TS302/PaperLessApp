package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.NfcTaggable
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.datetime.Clock
import kotlin.uuid.Uuid

class AssignmentRepositoryImpl(
    private val assetUserRepository: AssetUserRepository,
    private val nfcTaggableRepository: NfcTaggableRepository,
    private val repoScope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
) : AssignmentRepository {

    private val assignmentsState: MutableStateFlow<List<Assignment>> =
        MutableStateFlow(emptyList())

    override fun observeAll(): StateFlow<List<Assignment>> =
        assignmentsState.asStateFlow()

    override fun observeForEmployee(assetUserId: Uuid): StateFlow<List<Assignment>> =
        assignmentsState
            .map { allAssignments: List<Assignment> ->
                allAssignments.filter { assignment: Assignment ->
                    assignment.assetUserId == assetUserId && assignment.until == null
                }
            }
            .stateIn(repoScope, SharingStarted.Eagerly, emptyList())

    override fun observeForAsset(taggableId: Uuid): StateFlow<List<Assignment>> =
        assignmentsState
            .map { allAssignments: List<Assignment> ->
                allAssignments.filter { assignment: Assignment ->
                    assignment.tagId == taggableId && assignment.until == null
                }
            }
            .stateIn(repoScope, SharingStarted.Eagerly, emptyList())


    override suspend fun assign(
        taggableId: Uuid,
        toEmployeeId: Uuid,
        note: String?
    ): Assignment {

        assignmentsState.update { current: List<Assignment> ->
            val now = Clock.System.now()
            current.map { assignment: Assignment ->
                if (assignment.tagId == taggableId && assignment.until == null) {
                    assignment.copy(until = now)
                } else {
                    assignment
                }
            }
        }

        val now = Clock.System.now()
        val newAssignment = Assignment(
            id = Uuid.random(),
            assetUserId = toEmployeeId,
            tagId = taggableId,
            from = now,
            until = null,
            note = note
        )
        assignmentsState.update { current -> current + newAssignment }
        return newAssignment
    }

    override suspend fun unassign(taggableId: Uuid): Boolean {
        var changed = false
        assignmentsState.update { current: List<Assignment> ->
            val now = Clock.System.now()
            current.map { assignment: Assignment ->
                if (assignment.tagId == taggableId && assignment.until == null) {
                    changed = true
                    assignment.copy(until = now)
                } else {
                    assignment
                }
            }
        }
        return changed
    }

    override suspend fun closeAssignment(assignmentId: Uuid): Boolean {
        var changed = false
        assignmentsState.update { current: List<Assignment> ->
            val now = Clock.System.now()
            current.map { assignment: Assignment ->
                if (assignment.id == assignmentId && assignment.until == null) {
                    changed = true
                    assignment.copy(until = now)
                } else {
                    assignment
                }
            }
        }
        return changed
    }

    override suspend fun currentAssigneeOf(taggableId: Uuid): AssetUser? {
        val openAssignment: Assignment = assignmentsState.value
            .lastOrNull { a -> a.tagId == taggableId && a.until == null }
            ?: return null

        return assetUserRepository.getById(openAssignment.assetUserId)
    }

    override suspend fun lastAssigneesOf(
        taggableId: Uuid,
        limit: Int
    ): List<AssetUser> {
        val assignmentsForAsset: List<Assignment> = assignmentsState.value
            .filter { it.tagId == taggableId }
            .sortedByDescending { it.from }

        val previousAssignments: List<Assignment> = assignmentsForAsset
            .filter { it.until != null }

        val result = mutableListOf<AssetUser>()
        val seenEmployeeIds = mutableSetOf<Uuid>()

        for (assignment in previousAssignments) {
            if (result.size >= limit) break
            if (!seenEmployeeIds.add(assignment.assetUserId)) continue

            val employee = assetUserRepository.getById(assignment.assetUserId)
            if (employee != null) {
                result.add(employee)
            }
        }
        return result
    }

    override suspend fun lastAssignmentsOf(
        taggableId: Uuid,
        limit: Int
    ): List<Assignment> {
        return assignmentsState.value
            .filter { it.tagId == taggableId && it.until != null }
            .sortedByDescending { it.from }
            .take(limit)
    }

    override suspend fun assetsOf(assetUserId: Uuid): List<NfcTaggable> {
        val openAssignments: List<Assignment> = assignmentsState.value
            .filter { a -> a.assetUserId == assetUserId && a.until == null }

        if (openAssignments.isEmpty()) return emptyList()

        val taggableIds: Set<Uuid> = openAssignments.map { it.tagId }.toSet()
        val allTaggables: List<NfcTaggable> = nfcTaggableRepository.getAll()
        return allTaggables.filter { t -> t.id in taggableIds }
    }
}
