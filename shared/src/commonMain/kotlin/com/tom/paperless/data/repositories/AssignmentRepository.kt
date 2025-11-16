package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.NfcTaggable
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.Uuid

interface AssignmentRepository {
    fun observeAll(): StateFlow<List<Assignment>>
    fun observeForEmployee(employeeId: Uuid): StateFlow<List<Assignment>>
    fun observeForAsset(taggableId: Uuid): StateFlow<List<Assignment>>

    suspend fun currentAssigneeOf(taggableId: Uuid): Employee?

    suspend fun lastAssigneesOf(taggableId: Uuid, limit: Int = 3): List<Employee>
    suspend fun assetsOf(employeeId: Uuid): List<NfcTaggable>

    suspend fun assign(taggableId: Uuid, toEmployeeId: Uuid): Assignment
    suspend fun unassign(taggableId: Uuid): Boolean
    suspend fun closeAssignment(assignmentId: Uuid): Boolean
}