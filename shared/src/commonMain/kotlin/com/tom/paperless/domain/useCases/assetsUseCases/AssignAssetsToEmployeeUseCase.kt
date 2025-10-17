package com.tom.paperless.domain.useCases.assetsUseCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.TaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssignAssetsToEmployeeUseCase() : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()
    private val taggableRepository: TaggableRepository by inject()


    suspend operator fun invoke(employeeId: Uuid, assetIds: List<Uuid>) {
        require(assetIds.isNotEmpty()) { "Es wurden keine Assets angegeben." }

        // 1️⃣ Hole alle Assets anhand der IDs
        val allSelectedAssets: List<NfcTaggable> = taggableRepository.getByIds(assetIds)
        if (allSelectedAssets.size != assetIds.size) {
            error("Mindestens ein Asset wurde nicht gefunden.")
        }

        // 2️⃣ Prüfe, ob alle Assets zuweisbar und noch frei sind
        for (asset in allSelectedAssets) {
            ensureAssignable(asset)
            if (asset.tagStatus == TagStatus.inUse) {
                error("‘${asset.name}’ ist bereits im Einsatz.")
            }
        }

        // 3️⃣ Lege Zuweisungen an + ändere den Status auf 'im Einsatz'
        for (assetId in assetIds) {
            assignmentRepository.assign(assetId, employeeId)
            taggableRepository.updateStatus(assetId, TagStatus.inUse)
        }
    }

    private fun ensureAssignable(asset: NfcTaggable) {
        when (asset.targetType) {
            TargetType.Tool,
            TargetType.Vehicle,
            TargetType.Key -> Unit // alles erlaubt
            else -> error("Asset vom Typ ${asset.targetType} kann nicht zugewiesen werden.")
        }
    }
}