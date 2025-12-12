package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssetUserRepository
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class DeleteAssetUserUseCase() : KoinComponent {
    private val repository: AssetUserRepository by inject()

    suspend operator fun invoke(id: Uuid) {
        repository.delete(id)
    }
}