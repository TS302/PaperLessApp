package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.tom.paperless.domain.models.uiStates.LoginUiState
import com.tom.paperless.domain.useCases.GetLoggedInUserUseCase
import com.tom.paperless.domain.useCases.LoginUserUseCase
import com.tom.paperless.domain.useCases.LogoutUserUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update

class LoginViewModel(
    private val loginUserUseCase: LoginUserUseCase,
    private val getLoggedInUserUseCase: GetLoggedInUserUseCase,
    private val logoutUserUseCase: LogoutUserUseCase
) : ViewModel() {

    private val _uiStateInternal = MutableStateFlow(LoginUiState())

    // WICHTIG: Diese Annotation erzeugt in Swift die Properties `uiStateFlow` (AsyncSeq/Combine)
    // und `uiStatePublisher` (Combine).
    @NativeCoroutinesState
    val uiState: StateFlow<LoginUiState> = _uiStateInternal

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

    fun login() {
        val curr = _uiStateInternal.value
        val result = loginUserUseCase(email = curr.email, password = curr.password)
        _uiStateInternal.update { prev ->
            result.fold(
                onSuccess = { prev.copy(success = true, errorMessage = null, password = "") },
                onFailure = { error ->
                    prev.copy(success = false, errorMessage = error.message) }
            )
        }
    }

    fun logout() {
        logoutUserUseCase()
        _uiStateInternal.update { LoginUiState() }
    }

    /** WICHTIG: Erfolg **und** Misserfolg explizit in den State schreiben. */
    fun checkIfAlreadyLoggedIn() {
        val user = getLoggedInUserUseCase()
        _uiStateInternal.update { prev ->
            prev.copy(success = (user != null), errorMessage = null)
        }
    }

    fun reset() {
        _uiStateInternal.update { LoginUiState() }
    }
}