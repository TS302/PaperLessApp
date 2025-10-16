package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import kotlinx.coroutines.flow.StateFlow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class GetAllNfcTaggablesFlowUseCase() : KoinComponent {
    private val repository: NfcTaggableRepository by inject()
    @NativeCoroutines
    operator fun invoke(): StateFlow<List<NfcTaggable>> = repository.observeAll()
}