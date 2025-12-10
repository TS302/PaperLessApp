package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.NfcTaggable
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.Uuid

interface AssignmentRepository {
    fun observeAll(): StateFlow<List<Assignment>>
    fun observeForEmployee(assetUserId: Uuid): StateFlow<List<Assignment>>
    fun observeForAsset(taggableId: Uuid): StateFlow<List<Assignment>>

    suspend fun currentAssigneeOf(taggableId: Uuid): AssetUser?
    suspend fun lastAssignmentsOf(taggableId: Uuid, limit: Int = 3 ): List<Assignment>

    suspend fun lastAssigneesOf(taggableId: Uuid, limit: Int = 3): List<AssetUser>
    suspend fun assetsOf(assetUserId: Uuid): List<NfcTaggable>

    suspend fun assign(taggableId: Uuid, toEmployeeId: Uuid, note: String?): Assignment
    suspend fun unassign(taggableId: Uuid): Boolean
    suspend fun closeAssignment(assignmentId: Uuid): Boolean
}