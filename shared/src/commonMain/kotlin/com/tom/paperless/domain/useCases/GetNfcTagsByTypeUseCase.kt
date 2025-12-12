package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagType
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class GetNfcTagsByTypeUseCase() : KoinComponent {
    private val repository: NfcTaggableRepository by inject()
    suspend operator fun invoke(type: TagType): List<NfcTaggable> {
        return repository.getAllByType(type)
    }
}