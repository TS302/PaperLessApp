package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.UserRepository
import com.tom.paperless.domain.models.User

class LoginUserUseCase(
    private val repository: UserRepository = UserRepository
) {
    operator fun invoke(email: String, password: String): Result<User> {
        val user = repository.getByEmail(email) ?: return Result.failure(
            IllegalArgumentException("E-Mail nicht gefunden")
        )

        if (user.password != password) {
            return Result.failure(
                IllegalArgumentException("Passwort ist falsch")
            )
        }
        repository.getAll()
            .filter { it.isLoggedIn && it.email != email }
            .forEach { repository.update(it.copy(isLoggedIn = false))}

        val loggedInUser = user.copy(isLoggedIn = true)
        repository.update(loggedInUser)

        return Result.success(loggedInUser)
    }
}