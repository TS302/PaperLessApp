package com.tom.paperless.domain.useCases.assetsUseCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssignAssetToEmployeeUseCase : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()
    private val nfcTaggableRepository: NfcTaggableRepository by inject()

    suspend operator fun invoke(
        employeeId: Uuid,
        assetId: Uuid
    ) {
        val asset = nfcTaggableRepository.getById(assetId)
            ?: error("Asset $assetId nicht gefunden.")

        when (asset.targetType) {
            TargetType.Tool, TargetType.Vehicle, TargetType.Key -> {} // erlaubt
            else -> error("Asset vom Typ ${asset.targetType} kann nicht zugewiesen werden.")
        }
        assignmentRepository.assign(asset.id, employeeId)
        nfcTaggableRepository.updateStatus(asset.id, TagStatus.inUse)
    }
}