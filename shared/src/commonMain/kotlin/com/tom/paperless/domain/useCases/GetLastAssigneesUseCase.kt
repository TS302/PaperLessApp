package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.AssetUser
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class GetLastAssigneesUseCase : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()
    private val getUserById: GetAssetUserByIdUseCase by inject()

    suspend operator fun invoke(
        assetId: Uuid,
        limit: Int
    ): List<AssetUser> =
        assignmentRepository.getAll()
            .filter { it.tagId == assetId }
            .sortedByDescending { it.from }
            .mapNotNull { getUserById(it.assetUserId) }
            .distinctBy { it.id }
            .take(limit)
}