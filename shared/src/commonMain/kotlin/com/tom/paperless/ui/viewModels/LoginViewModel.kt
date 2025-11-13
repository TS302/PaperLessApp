package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.tom.paperless.domain.models.uiStates.LoginUiState
import com.tom.paperless.domain.useCases.GetLoggedInUserUseCase
import com.tom.paperless.domain.useCases.LoginUserUseCase
import com.tom.paperless.domain.useCases.LogoutUserUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import com.rickclephas.kmp.observableviewmodel.launch
import kotlinx.coroutines.flow.asStateFlow

class LoginViewModel : ViewModel(), KoinComponent {

    private val loginUserUseCase: LoginUserUseCase by inject()
    private val getLoggedInUserUseCase: GetLoggedInUserUseCase by inject()
    private val logoutUserUseCase: LogoutUserUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, LoginUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<LoginUiState> = _uiState.asStateFlow()

    fun onEmailChanged(newEmail: String) {
        _uiState.update { prev -> prev.copy(email = newEmail.trim(), errorMessage = null, success = false) }
    }

    fun onPasswordChanged(newPassword: String) {
        _uiState.update { prev -> prev.copy(password = newPassword, errorMessage = null, success = false) }
    }

    fun login() = viewModelScope.launch {
        val current = _uiState.value
        val result = loginUserUseCase(
            emailAddress = current.email,
            plainPassword = current.password
        )
        _uiState.update { prev ->
            result.fold(
                onSuccess = { prev.copy(success = true, errorMessage = null, password = "") },
                onFailure = { error -> prev.copy(success = false, errorMessage = error.message) }
            )
        }
    }

    fun logout() = viewModelScope.launch {
        runCatching { logoutUserUseCase() }
        _uiState.update { LoginUiState() }
    }

    fun checkIfAlreadyLoggedIn() {
        val user = getLoggedInUserUseCase()
        _uiState.update { prev -> prev.copy(success = (user != null), errorMessage = null) }
    }

    fun reset() {
        _uiState.update { LoginUiState() }
    }
}