package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.domain.models.AssetUser
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class UpdateAssetUserUseCase() : KoinComponent {
    private val repository: AssetUserRepository by inject()

    suspend operator fun invoke(assetUser: AssetUser): AssetUser {
        val cleaned = assetUser.copy(name = assetUser.name.trim())
        require(cleaned.name.isNotBlank()) { "Name darf nicht leer sein." }
        return repository.update(cleaned) ?: error("Mitarbeiter nicht gefunden.")
    }
}