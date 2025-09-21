package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.UserRepository

class LogoutUserUseCase(
    private val repository: UserRepository = UserRepository
) {
    operator fun invoke() {
        repository.getAll()
            .filter { it.isLoggedIn }
            .forEach { user -> repository.update(user.copy(isLoggedIn = false)) }
    }
}