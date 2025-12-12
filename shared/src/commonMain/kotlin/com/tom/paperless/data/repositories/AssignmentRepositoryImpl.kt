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
    private val nfcTaggableRepository: NfcTaggableRepository
) : AssignmentRepository {

    override suspend fun add(assignment: Assignment): Assignment {
        return assignment
    }

    override suspend fun getAll(): List<Assignment> {
        return emptyList()
    }

    override suspend fun getById(id: Uuid): Assignment? {
        return null
    }

    override suspend fun getByAsset(taggableId: Uuid): List<Assignment> {
        return emptyList()
    }

    override suspend fun getByEmployee(assetUserId: Uuid): List<Assignment> {
        return emptyList()
    }

    override suspend fun update(assignment: Assignment): Assignment? {
        return assignment
    }

    override suspend fun delete(id: Uuid): Boolean {
        return true
    }

}
