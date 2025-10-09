package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable

class AddNfcTaggableUseCase(
    private val repository: NfcTaggableRepository
) {
    @NativeCoroutines
    suspend operator fun invoke(itemToAdd: NfcTaggable): NfcTaggable {
        require(itemToAdd.name.isNotBlank()) { "Name darf nicht leer sein." }
        return repository.add(itemToAdd)
    }
}