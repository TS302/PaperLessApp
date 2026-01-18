package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagType
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.getValue

class GetNfcTagsByTypeUseCase() : KoinComponent {
    private val repository: NfcTaggableRepository by inject()

    @NativeCoroutines
    suspend fun invoke(type: TagType): List<NfcTaggable> {
        return repository
            .getAll()
            .filter { it.tagType == type }
    }
}