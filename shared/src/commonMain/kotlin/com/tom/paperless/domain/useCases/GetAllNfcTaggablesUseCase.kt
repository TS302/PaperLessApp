package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class GetAllNfcTaggablesUseCase() : KoinComponent {
    private val repository: NfcTaggableRepository by inject()
    @NativeCoroutines
    suspend operator fun invoke(): List<NfcTaggable> = repository.getAll()
}