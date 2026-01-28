package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.enums.TagStatus
import kotlinx.datetime.Clock
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class ReturnAssetUseCase : KoinComponent {
    private val assignmentRepository: AssignmentRepository by inject()
    private val updateNfcTagStatus: UpdateNfcTagStatusUseCase by inject()

    suspend operator fun invoke(assetId: Uuid, untilNote: String?) {

        val assignments = assignmentRepository.getByAsset(assetId)

        val activeAssignment = assignments.firstOrNull { it.until == null }
            ?: error("Kein aktives Assignment für Asset $assetId gefunden")

        val closedAssignment = activeAssignment.copy(
            until = Clock.System.now(),
            untilNote = untilNote
        )

        assignmentRepository.update(closedAssignment)

        updateNfcTagStatus(
            id = assetId,
            status = TagStatus.available
        )
    }
}