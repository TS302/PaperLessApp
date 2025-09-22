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

    private val _uiState = MutableStateFlow(LoginUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<LoginUiState> = _uiState

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

    fun login() {
        val curr = _uiState.value
        val result = loginUserUseCase(email = curr.email, password = curr.password)
        _uiState.update { prev ->
            result.fold(
                onSuccess = { prev.copy(success = true, errorMessage = null, password = "") },
                onFailure = { error ->
                    prev.copy(success = false, errorMessage = error.message) }
            )
        }
    }

    fun logout() {
        logoutUserUseCase()
        _uiState.update { LoginUiState() }
    }

    fun checkIfAlreadyLoggedIn() {
        val user = getLoggedInUserUseCase()
        _uiState.update { prev ->
            prev.copy(success = (user != null), errorMessage = null)
        }
    }

    fun reset() {
        _uiState.update { LoginUiState() }
    }
}