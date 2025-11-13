package com.tom.paperless.domain.useCases

import com.tom.paperless.auth.AuthService
import com.tom.paperless.domain.models.Role
import com.tom.paperless.domain.models.User
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class RegisterUserUseCase : KoinComponent {
    private val authService: AuthService by inject()

    suspend operator fun invoke(
        firstName: String,
        lastName: String,
        emailAddress: String,
        plainPassword: String
    ): Result<User> = runCatching {
        val normalizedEmail = emailAddress.trim()
        require(normalizedEmail.isNotEmpty()) { "E-Mail fehlt" }
        require(plainPassword.length >= 4) { "Passwort zu kurz" }

        authService.registerEmailPassword(normalizedEmail, plainPassword)

        User(
            firstname = firstName.trim(),
            lastname = lastName.trim(),
            email = normalizedEmail,
            password = "",
            role = Role.USER,
            isLoggedIn = true
        )
    }
}