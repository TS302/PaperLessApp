package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable

class SaveNfcTaggableUseCase(
    private val repository: NfcTaggableRepository
) {
    @NativeCoroutines
    suspend operator fun invoke(itemToSave: NfcTaggable): NfcTaggable {
        require(itemToSave.name.isNotBlank()) { "Name darf nicht leer sein." }
        return repository.update(itemToSave)
            ?: error("Item konnte nicht aktualisiert werden (nicht gefunden).")
    }
}