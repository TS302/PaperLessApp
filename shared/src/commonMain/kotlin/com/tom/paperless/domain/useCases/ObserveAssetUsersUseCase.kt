package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.domain.models.AssetUser
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class ObserveAssetUsersUseCase(): KoinComponent {
    private val repository: AssetUserRepository by inject()

    operator fun invoke(): Flow<List<AssetUser>> =
        flow {
            emit(repository.getAll())
        }
}