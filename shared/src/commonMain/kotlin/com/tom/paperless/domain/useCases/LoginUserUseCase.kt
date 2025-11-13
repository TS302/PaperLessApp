package com.tom.paperless.domain.useCases

import com.tom.paperless.auth.AuthService
import com.tom.paperless.data.repositories.UserRepository
import com.tom.paperless.domain.models.Role
import com.tom.paperless.domain.models.User
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class LoginUserUseCase : KoinComponent {

    private val authService: AuthService by inject()

    suspend operator fun invoke(
        emailAddress: String,
        plainPassword: String
    ): Result<User> = runCatching {
        val normalizedEmail = emailAddress.trim()
        require(normalizedEmail.isNotEmpty()) { "E-Mail fehlt" }
        require(plainPassword.isNotEmpty()) { "Passwort fehlt" }

        authService.signInEmailPassword(
            emailAddress = normalizedEmail,
            plainPassword = plainPassword
        )

        User(
            firstname = "",
            lastname = "",
            email = normalizedEmail,
            password = "",
            role = Role.USER,
            isLoggedIn = true
        )
    }
}