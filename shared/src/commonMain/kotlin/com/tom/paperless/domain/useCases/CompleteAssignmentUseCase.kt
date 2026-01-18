package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.mappers.withStatus
import com.tom.paperless.domain.models.enums.TagStatus
import kotlinx.datetime.Instant
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class CompleteAssignmentUseCase : KoinComponent {

    private val assignmentRepo: AssignmentRepository by inject()
    private val assetRepo: NfcTaggableRepository by inject()

    suspend operator fun invoke(
        assignmentId: Uuid,
        assetId: Uuid,
        untilMillis: Long
    ) {
        val current = assignmentRepo.getById(assignmentId)
            ?: error("Assignment not found: $assignmentId")

        assignmentRepo.update(
            current.copy(until = Instant.fromEpochMilliseconds(untilMillis))
        )

        val asset = assetRepo.getById(assetId)
            ?: error("Asset not found: $assetId")

        assetRepo.update(
            itemToUpdate = asset.withStatus(TagStatus.available)
        )
    }
}