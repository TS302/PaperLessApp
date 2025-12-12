package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.domain.models.AssetUser
import kotlinx.coroutines.flow.Flow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class GetAllAssetUsersUseCase() : KoinComponent {
    private val repository: AssetUserRepository by inject()

    suspend operator fun invoke(): List<AssetUser> {
        return repository.getAll()
    }
}