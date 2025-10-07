package com.tom.paperless.data.repositories

import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.Employee
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update
import kotlinx.datetime.Clock
import kotlin.uuid.Uuid
import com.tom.paperless.domain.models.NfcTaggable

object AssignmentRepositoryImpl : AssignmentRepository {
    private val _assignments = MutableStateFlow<List<Assignment>>(emptyList())
    override fun observeAll() = _assignments
    override fun observeForEmployee(employeeId: Uuid) =
        _assignments.mapState { it.filter { a -> a.employeeId == employeeId && a.until == null } }

    override fun observeForAsset(taggableId: Uuid) =
        _assignments.mapState { it.filter { a -> a.taggableId == taggableId && a.until == null } }

    override suspend fun assign(taggableId: Uuid, toEmployeeId: Uuid): Assignment {
        // Optional: offene Zuweisung vorher schließen
        _assignments.update { cur ->
            val closed = cur.map {
                if (it.taggableId == taggableId && it.until == null) it.copy(until = Clock.System.now()) else it
            }
            closed + Assignment(Uuid.random(), toEmployeeId, taggableId)
        }
        return _assignments.value.last()
    }

    override suspend fun unassign(taggableId: Uuid): Boolean {
        var changed = false
        _assignments.update { cur ->
            cur.map {
                if (it.taggableId == taggableId && it.until == null) {
                    changed = true; it.copy(until = Clock.System.now())
                } else it
            }
        }
        return changed
    }

    override suspend fun closeAssignment(assignmentId: Uuid): Boolean {
        var changed = false
        _assignments.update { cur ->
            cur.map { if (it.id == assignmentId && it.until == null) { changed = true; it.copy(until = Clock.System.now()) } else it }
        }
        return changed
    }

    // Helpers (wenn du willst): currentAssigneeOf / assetsOf
    override suspend fun currentAssigneeOf(taggableId: Uuid): Employee? = null
    override suspend fun assetsOf(employeeId: Uuid): List<NfcTaggable> = emptyList()
}

private fun <T, R> StateFlow<T>.mapState(transform: (T) -> R): StateFlow<R> =
    MutableStateFlow(transform(value)).also { out ->
    }