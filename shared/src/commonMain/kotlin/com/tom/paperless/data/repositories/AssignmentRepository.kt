package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.NfcTaggable
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.Uuid

interface AssignmentRepository {

    suspend fun add(assignment: Assignment): Assignment
    suspend fun getAll(): List<Assignment>
    suspend fun getById(id: Uuid): Assignment?
    suspend fun getByAsset(taggableId: Uuid): List<Assignment>
    suspend fun getByEmployee(assetUserId: Uuid): List<Assignment>
    suspend fun update(assignment: Assignment): Assignment?
    suspend fun delete(id: Uuid): Boolean
}