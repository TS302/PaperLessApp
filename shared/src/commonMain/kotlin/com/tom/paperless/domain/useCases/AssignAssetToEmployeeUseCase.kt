package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlinx.datetime.Clock
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssignAssetToEmployeeUseCase : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()
    private val nfcTaggableRepository: NfcTaggableRepository by inject()
    private val updateNfcTagStatus: UpdateNfcTagStatusUseCase by inject()

    suspend operator fun invoke(
        employeeId: Uuid,
        assetId: Uuid,
        fromNote: String?
    ) {
        val asset = nfcTaggableRepository.getById(assetId)
            ?: error("Asset $assetId nicht gefunden")

        when (asset.tagType) {
            TagType.Tool,
            TagType.Vehicle,
            TagType.Key -> Unit
            else -> error("Asset vom Typ ${asset.tagType} kann nicht zugewiesen werden")
        }

        val now = Clock.System.now()

        val existingAssignments = assignmentRepository.getByAsset(asset.id)
        val openAssignment = existingAssignments.firstOrNull { it.until == null }

        if (openAssignment != null) {
            assignmentRepository.update(openAssignment.copy(until = now))
        }

        val assignment = Assignment(
            id = Uuid.random(),
            tagId = asset.id,
            assetUserId = employeeId,
            from = Clock.System.now(),
            fromNote = fromNote,
            until = null,
            untilNote = null
        )

        assignmentRepository.add(assignment)

        updateNfcTagStatus(
            id = asset.id,
            status = TagStatus.inUse
        )
    }
}