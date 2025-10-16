package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TargetType
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class GetNfcTaggableByIdUseCase() : KoinComponent {

    private val repository: NfcTaggableRepository by inject()
    @NativeCoroutines
    suspend operator fun invoke(id: Uuid): NfcTaggable? =
        repository.getById(id)
}