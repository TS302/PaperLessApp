package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable

class GetAllNfcTaggablesUseCase(
    private val repository: NfcTaggableRepository
) {
    @NativeCoroutines
    suspend operator fun invoke(): List<NfcTaggable> = repository.getAll()
}