package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.UserRepository
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class LogoutUserUseCase() : KoinComponent {

    private val repository: UserRepository by inject()

    operator fun invoke() {
        repository.getAll()
            .filter { it.isLoggedIn }
            .forEach { user -> repository.update(user.copy(isLoggedIn = false)) }
    }
}