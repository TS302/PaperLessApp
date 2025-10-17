package com.tom.paperless.domain.useCases.assetsUseCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.TaggableRepository
import com.tom.paperless.domain.models.enums.TagStatus
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class ReturnAssetsUseCase() : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()
    private val taggableRepository: TaggableRepository by inject()

    suspend operator fun invoke(assetIds: List<Uuid>) {
        require(assetIds.isNotEmpty()) { "Es wurden keine Assets angegeben." }

        var anyChanged = false
        for (assetId in assetIds) {
            val wasUnassigned = assignmentRepository.unassign(assetId)
            if (wasUnassigned) {
                anyChanged = true
                taggableRepository.updateStatus(assetId, TagStatus.available)
            }
        }

        if (!anyChanged) {
            error("Keine offenen Zuweisungen gefunden.")
        }
    }
}