package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.AssetUser
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class GetCurrentAssigneeUseCase : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()
    private val getUserById: GetAssetUserByIdUseCase by inject()

    suspend operator fun invoke(assetId: Uuid): AssetUser? {
        val assignment = assignmentRepository
            .getAll()
            .firstOrNull { it.tagId == assetId && it.until == null }
            ?: return null

        return getUserById(assignment.assetUserId)
    }
}

