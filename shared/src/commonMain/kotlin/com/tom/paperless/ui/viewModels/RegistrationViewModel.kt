package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.tom.paperless.domain.models.User
import com.tom.paperless.domain.models.uiStates.RegistrationUiState
import com.tom.paperless.domain.useCases.LoginUserUseCase
import com.tom.paperless.domain.useCases.RegisterUserUseCase
import com.tom.paperless.domain.useCases.RegisterUserOutcome
import com.tom.paperless.domain.errors.RegistrationError
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update

class RegistrationViewModel(
    private val registerUserUseCase: RegisterUserUseCase,
    private val loginUserUseCase: LoginUserUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(RegistrationUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<RegistrationUiState> = _uiState

    fun onFirstnameChanged(newFirstname: String) {
        _uiState.update { prev ->
            prev.copy(firstname = newFirstname.trim(), errorMessage = null, success = false)
        }
    }

    fun onLastnameChanged(newLastname: String) {
        _uiState.update { prev ->
            prev.copy(lastname = newLastname.trim(), errorMessage = null, success = false)
        }
    }

    fun onEmailChanged(newEmail: String) {
        _uiState.update { prev ->
            prev.copy(email = newEmail.trim(), errorMessage = null, success = false)
        }
    }

    fun onPasswordChanged(newPassword: String) {
        _uiState.update { prev ->
            prev.copy(password = newPassword, errorMessage = null, success = false)
        }
    }

    fun onConfirmPasswordChanged(newConfirmPassword: String) {
        _uiState.update { prev ->
            prev.copy(confirmPassword = newConfirmPassword, errorMessage = null, success = false)
        }
    }

    fun register() {
        val current = _uiState.value

        if (current.password.isBlank() ||
            current.confirmPassword.isBlank() ||
            current.password != current.confirmPassword
        ) {
            setError("Passwörter stimmen nicht überein.")
            return
        }

        val normalizedEmail = current.email.trim().lowercase()

        when (val outcome = registerUserUseCase(
            firstname = current.firstname,
            lastname = current.lastname,
            email = normalizedEmail,
            password = current.password
        )) {
            is RegisterUserOutcome.Success -> {
                val loginResult: Result<User> = loginUserUseCase(
                    email = normalizedEmail,
                    password = current.password
                )

                val newState: RegistrationUiState = loginResult.fold(
                    onSuccess = { _: User ->
                        current.copy(
                            success = true,
                            errorMessage = null,
                            password = "",
                            confirmPassword = ""
                        )
                    },
                    onFailure = { e: Throwable ->
                        current.copy(
                            success = false,
                            errorMessage = e.message
                        )
                    }
                )
                _uiState.value = newState
            }

            is RegisterUserOutcome.Failure -> {
                _uiState.update { prev ->
                    prev.copy(
                        success = false,
                        errorMessage = outcome.error.toHumanMessage()
                    )
                }
            }
        }
    }

    fun reset() {
        _uiState.update { RegistrationUiState() }
    }

    fun clearError() {
        _uiState.update { prev -> prev.copy(errorMessage = null) }
    }

    private fun setError(message: String) {
        _uiState.update { prev ->
            prev.copy(success = false, errorMessage = message)
        }
    }

    /** Mapping der domänenspezifischen Fehler auf Anzeigenachrichten. */
    private fun RegistrationError.toHumanMessage(): String = when (this) {
        RegistrationError.MissingFirstnameOrLastname -> "Bitte Vor- und Nachname eingeben"
        RegistrationError.MissingEmail -> "Bitte E-Mail eingeben"
        RegistrationError.PasswordTooShort -> "Passwort zu kurz (min. 4 Zeichen)"
        RegistrationError.EmailAlreadyUsed -> "E-Mail ist bereits registriert"
        is RegistrationError.Unknown -> this.message ?: "Unbekannter Fehler"
    }
}