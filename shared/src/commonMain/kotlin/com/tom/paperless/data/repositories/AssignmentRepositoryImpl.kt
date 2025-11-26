package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.Employee
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
    private val employeeRepository: EmployeeRepository,
    private val nfcTaggableRepository: NfcTaggableRepository,
    private val repoScope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
) : AssignmentRepository {

    private val assignmentsState: MutableStateFlow<List<Assignment>> =
        MutableStateFlow(emptyList())

    override fun observeAll(): StateFlow<List<Assignment>> =
        assignmentsState.asStateFlow()

    override fun observeForEmployee(employeeId: Uuid): StateFlow<List<Assignment>> =
        assignmentsState
            .map { allAssignments: List<Assignment> ->
                allAssignments.filter { assignment: Assignment ->
                    assignment.employeeId == employeeId && assignment.until == null
                }
            }
            .stateIn(repoScope, SharingStarted.Eagerly, emptyList())

    override fun observeForAsset(taggableId: Uuid): StateFlow<List<Assignment>> =
        assignmentsState
            .map { allAssignments: List<Assignment> ->
                allAssignments.filter { assignment: Assignment ->
                    assignment.taggableId == taggableId && assignment.until == null
                }
            }
            .stateIn(repoScope, SharingStarted.Eagerly, emptyList())


    override suspend fun assign(
        taggableId: Uuid,
        toEmployeeId: Uuid,
        note: String?
    ): Assignment {
        // Offene Zuweisung für dieses Asset schließen
        assignmentsState.update { current: List<Assignment> ->
            val now = Clock.System.now()
            current.map { assignment: Assignment ->
                if (assignment.taggableId == taggableId && assignment.until == null) {
                    assignment.copy(until = now)
                } else {
                    assignment
                }
            }
        }

        val now = Clock.System.now()
        val newAssignment = Assignment(
            id = Uuid.random(),
            employeeId = toEmployeeId,
            taggableId = taggableId,
            from = now,
            until = null,
            note = note          // 🔥 Kommentar speichern
        )
        assignmentsState.update { current -> current + newAssignment }
        return newAssignment
    }


//    override suspend fun assign(
//        taggableId: Uuid,
//        toEmployeeId: Uuid,
//        note: String?
//    ): Assignment {
//        assignmentsState.update { current: List<Assignment> ->
//            val now = Clock.System.now()
//            current.map { assignment: Assignment ->
//                if (assignment.taggableId == taggableId && assignment.until == null) {
//                    assignment.copy(until = now)
//                } else {
//                    assignment
//                }
//            }
//        }
//
//        val newAssignment = Assignment(
//            id = Uuid.random(),
//            employeeId = toEmployeeId,
//            taggableId = taggableId,
//            from = Clock.System.now(),
//            until = null,
//            note = note
//        )
//        assignmentsState.update { current -> current + newAssignment }
//        return newAssignment
//    }

    override suspend fun unassign(taggableId: Uuid): Boolean {
        var changed = false
        assignmentsState.update { current: List<Assignment> ->
            val now = Clock.System.now()
            current.map { assignment: Assignment ->
                if (assignment.taggableId == taggableId && assignment.until == null) {
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

    override suspend fun currentAssigneeOf(taggableId: Uuid): Employee? {
        val openAssignment: Assignment = assignmentsState.value
            .lastOrNull { a -> a.taggableId == taggableId && a.until == null }
            ?: return null

        return employeeRepository.getById(openAssignment.employeeId)
    }

    override suspend fun lastAssigneesOf(
        taggableId: Uuid,
        limit: Int
    ): List<Employee> {
        val assignmentsForAsset: List<Assignment> = assignmentsState.value
            .filter { it.taggableId == taggableId }
            .sortedByDescending { it.from }

        val previousAssignments: List<Assignment> = assignmentsForAsset
            .filter { it.until != null }

        val result = mutableListOf<Employee>()
        val seenEmployeeIds = mutableSetOf<Uuid>()

        for (assignment in previousAssignments) {
            if (result.size >= limit) break
            if (!seenEmployeeIds.add(assignment.employeeId)) continue

            val employee = employeeRepository.getById(assignment.employeeId)
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
            .filter { it.taggableId == taggableId && it.until != null }
            .sortedByDescending { it.from }
            .take(limit)
    }

    override suspend fun assetsOf(employeeId: Uuid): List<NfcTaggable> {
        val openAssignments: List<Assignment> = assignmentsState.value
            .filter { a -> a.employeeId == employeeId && a.until == null }

        if (openAssignments.isEmpty()) return emptyList()

        val taggableIds: Set<Uuid> = openAssignments.map { it.taggableId }.toSet()
        val allTaggables: List<NfcTaggable> = nfcTaggableRepository.getAll()
        return allTaggables.filter { t -> t.id in taggableIds }
    }
}
