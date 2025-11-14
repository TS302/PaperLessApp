package com.tom.paperless.domain.useCases.assetsUseCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.enums.TagStatus
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class ReturnAssetUseCase : KoinComponent {
    private val assignmentRepository: AssignmentRepository by inject()
    private val nfcTaggableRepository: NfcTaggableRepository by inject()

    suspend operator fun invoke(assetId: Uuid) {
        try {
            assignmentRepository.unassign(assetId)
            nfcTaggableRepository.updateStatus(assetId, TagStatus.available)

            println("Asset $assetId wurde erfolgreich freigegeben.")
        } catch (e: Exception) {
            println("Fehler beim Freigeben des Assets $assetId: ${e.message}")
            throw e
        }
    }
}