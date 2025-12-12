package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.Assignment
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class GetAssignmentsByAssetUseCase : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()

    suspend operator fun invoke(assetId: Uuid): List<Assignment> {
        return assignmentRepository.getByAsset(assetId)
    }
}
