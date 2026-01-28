package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.enums.TagStatus
import kotlinx.datetime.Clock
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class ReassignAssetUseCase : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()
    private val updateNfcTagStatus: UpdateNfcTagStatusUseCase by inject()

    suspend operator fun invoke(
        assetId: Uuid,
        newEmployeeId: Uuid,
        note: String?
    ) {
        val assignments = assignmentRepository.getByAsset(assetId)

        val activeAssignment = assignments.firstOrNull { it.until == null }
            ?: error("Kein aktives Assignment gefunden")

        // 1️⃣ altes Assignment schließen
        assignmentRepository.update(
            activeAssignment.copy(
                until = Clock.System.now(),
                untilNote = note
            )
        )

        // 2️⃣ neues Assignment erstellen
        assignmentRepository.add(
            Assignment(
                id = Uuid.random(),
                assetUserId = newEmployeeId,
                tagId = assetId,
                from = Clock.System.now(),
                fromNote = note
            )
        )

        // 3️⃣ Status EINMAL setzen
        updateNfcTagStatus(assetId, TagStatus.inUse)
    }
}