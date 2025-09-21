package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.UserRepository
import com.tom.paperless.domain.models.User

class GetLoggedInUserUseCase(
    private val repository: UserRepository = UserRepository
) {
    operator fun invoke(): User? = repository.getAll()
        .firstOrNull { it.isLoggedIn }
}