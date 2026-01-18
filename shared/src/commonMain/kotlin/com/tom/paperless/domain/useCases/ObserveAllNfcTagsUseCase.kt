package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class ObserveAllNfcTagsUseCase : KoinComponent {
    private val repository: NfcTaggableRepository by inject()

    fun observe(onChange: (List<NfcTaggable>) -> Unit) {
        repository.observeAll(onChange)
    }

    fun stop() {
        repository.stopObserving()
    }

    suspend fun load(): List<NfcTaggable>  {
        return repository.getAll()
    }
}