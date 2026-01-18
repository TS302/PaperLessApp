package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.domain.models.AssetUser
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class ObserveAllAssetUsersUseCase(): KoinComponent {
    private val repository: AssetUserRepository by inject()

    fun observe(onChange: (List<AssetUser>) -> Unit) {
        repository.observeAll(onChange)
    }

    fun stop() {
        repository.stopObserving()
    }

    suspend fun load(): List<AssetUser> {
        return repository.getAll()
    }
}