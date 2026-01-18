package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.Assignment
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class ObserveAssignmentsByAssetUseCase : KoinComponent {

    private val repository: AssignmentRepository by inject()

    fun observe(
        assetId: Uuid,
        onChange: (List<Assignment>) -> Unit
    ) {
        repository.observeByAsset(assetId, onChange)
    }

    fun stop() {
        repository.stopObserving()
    }
}