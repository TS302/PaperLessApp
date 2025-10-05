package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import kotlinx.coroutines.flow.StateFlow

class GetAllNfcTaggablesFlowUseCase(
    private val repository: NfcTaggableRepository
) {
    @NativeCoroutines
    operator fun invoke(): StateFlow<List<NfcTaggable>> = repository.observeAll()
}