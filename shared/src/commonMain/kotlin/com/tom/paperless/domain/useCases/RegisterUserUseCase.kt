package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.UserRepository
import com.tom.paperless.domain.errors.RegistrationError
import com.tom.paperless.domain.errors.RegistrationException
import com.tom.paperless.domain.models.Role
import com.tom.paperless.domain.models.User

/**
 * Ergebnis-Typ ohne rohe Exceptions nach außen.
 */
sealed class RegisterUserOutcome {
    data class Success(val user: User) : RegisterUserOutcome()
    data class Failure(val error: RegistrationError) : RegisterUserOutcome()
}

class RegisterUserUseCase(
    private val repository: UserRepository = UserRepository
) {

    /**
     * Validiert Eingaben, legt User an, mapped Fehler auf domänenspezifische Typen.
     * Intern nutzen wir runCatching + Exceptions, nach außen nur RegisterUserOutcome.
     */
    operator fun invoke(
        firstname: String,
        lastname: String,
        email: String,
        password: String
    ): RegisterUserOutcome {
        val trimmedFirstname = firstname.trim()
        val trimmedLastname = lastname.trim()
        val trimmedEmail = email.trim()

        val result = runCatching {
            if (trimmedFirstname.isEmpty() || trimmedLastname.isEmpty()) {
                throw RegistrationException(RegistrationError.MissingFirstnameOrLastname)
            }
            if (trimmedEmail.isEmpty()) {
                throw RegistrationException(RegistrationError.MissingEmail)
            }
            if (password.length < 4) {
                throw RegistrationException(RegistrationError.PasswordTooShort)
            }
            if (repository.getByEmail(trimmedEmail) != null) {
                throw RegistrationException(RegistrationError.EmailAlreadyUsed)
            }

            // --- Anlage ---
            val newUser = User(
                firstname = trimmedFirstname,
                lastname = trimmedLastname,
                email = trimmedEmail,
                password = password,
                role = Role.USER,
                isLoggedIn = false
            )
            repository.add(newUser)
            newUser
        }

        // --- Mapping auf domänenspezifisches Ergebnis-Objekt ---
        return result.fold(
            onSuccess = { user -> RegisterUserOutcome.Success(user) },
            onFailure = { throwable ->
                val error = (throwable as? RegistrationException)?.reason
                    ?: RegistrationError.Unknown(throwable.message)
                RegisterUserOutcome.Failure(error)
            }
        )
    }
}