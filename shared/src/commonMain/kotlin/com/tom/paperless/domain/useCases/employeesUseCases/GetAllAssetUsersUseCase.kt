package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.domain.models.AssetUser
import kotlinx.coroutines.flow.Flow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class GetAllAssetUsersUseCase() : KoinComponent {
    private val repository: AssetUserRepository by inject()
    operator fun invoke(): Flow<List<AssetUser>> = repository.getAllFlow()
}