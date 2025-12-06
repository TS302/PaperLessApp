package com.tom.paperless.domain.useCases.employeesUseCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.domain.models.AssetUser
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class GetAssetUserByIdUseCase() : KoinComponent {
    private val repository: AssetUserRepository by inject()
    @NativeCoroutines
    suspend operator fun invoke(id: Uuid): AssetUser? =
        repository.getById(id)
}