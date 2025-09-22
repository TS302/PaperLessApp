package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import kotlin.native.HiddenFromObjC

class UpdateNfcTaggableUseCase(
    private val repository: NfcTaggableRepository
) {
    @HiddenFromObjC
    suspend operator fun invoke(item: NfcTaggable): Boolean =
        repository.update(item)
}