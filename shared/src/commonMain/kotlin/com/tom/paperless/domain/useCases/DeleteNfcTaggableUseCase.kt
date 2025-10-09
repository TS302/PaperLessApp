package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import kotlin.uuid.Uuid

class DeleteNfcTaggableUseCase(
    private val repository: NfcTaggableRepository
) {
    @NativeCoroutines
    suspend operator fun invoke(id: Uuid): Boolean =
        repository.delete(id)
}