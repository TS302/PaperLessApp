package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TargetType
import kotlin.uuid.Uuid

class GetNfcTaggableByIdUseCase(
    private val repository: NfcTaggableRepository
) {
    @NativeCoroutines
    suspend operator fun invoke(type: TargetType, id: Uuid): NfcTaggable? =
        repository.getById(type, id)
}