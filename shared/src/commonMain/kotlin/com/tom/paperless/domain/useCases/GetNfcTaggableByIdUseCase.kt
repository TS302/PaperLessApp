package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.TargetType
import kotlin.native.HiddenFromObjC
import kotlin.uuid.Uuid

class GetNfcTaggableByIdUseCase(
    private val repository: NfcTaggableRepository
) {
    @HiddenFromObjC
    suspend operator fun invoke(type: TargetType, id: Uuid): NfcTaggable? =
        repository.getById(type, id)
}