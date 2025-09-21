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

    private val _uiStateInternal = MutableStateFlow(RegistrationUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<RegistrationUiState> = _uiStateInternal

    fun onFirstnameChanged(newFirstname: String) {
        _uiStateInternal.update { prev ->
            prev.copy(firstname = newFirstname.trim(), errorMessage = null, success = false)
        }
    }

    fun onLastnameChanged(newLastname: String) {
        _uiStateInternal.update { prev ->
            prev.copy(lastname = newLastname.trim(), errorMessage = null, success = false)
        }
    }

    fun onEmailChanged(newEmail: String) {
        _uiStateInternal.update { prev ->
            prev.copy(email = newEmail.trim(), errorMessage = null, success = false)
        }
    }

    fun onPasswordChanged(newPassword: String) {
        _uiStateInternal.update { prev ->
            prev.copy(password = newPassword, errorMessage = null, success = false)
        }
    }

    fun onConfirmPasswordChanged(newConfirmPassword: String) {
        _uiStateInternal.update { prev ->
            prev.copy(confirmPassword = newConfirmPassword, errorMessage = null, success = false)
        }
    }

    fun register() {
        val current = _uiStateInternal.value

        // 1) Client-Validierung: Passwörter müssen übereinstimmen
        if (current.password.isBlank() ||
            current.confirmPassword.isBlank() ||
            current.password != current.confirmPassword
        ) {
            setError("Passwörter stimmen nicht überein.")
            return
        }

        // 2) E-Mail normalisieren
        val normalizedEmail = current.email.trim().lowercase()

        // 3) Registrieren (liefert RegisterUserOutcome)
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
                _uiStateInternal.value = newState
            }

            is RegisterUserOutcome.Failure -> {
                _uiStateInternal.update { prev ->
                    prev.copy(
                        success = false,
                        errorMessage = outcome.error.toHumanMessage()
                    )
                }
            }
        }
    }

    fun reset() {
        _uiStateInternal.update { RegistrationUiState() }
    }

    /** Für SwiftUI-Alert: Fehlermeldung nach dem Anzeigen zurücksetzen. */
    fun clearError() {
        _uiStateInternal.update { prev -> prev.copy(errorMessage = null) }
    }

    private fun setError(message: String) {
        _uiStateInternal.update { prev ->
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