package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import kotlin.native.HiddenFromObjC

class GetAllNfcTaggablesUseCase(
    private val repository: NfcTaggableRepository
) {
    @HiddenFromObjC
    suspend operator fun invoke(): List<NfcTaggable> = repository.getAll()
}