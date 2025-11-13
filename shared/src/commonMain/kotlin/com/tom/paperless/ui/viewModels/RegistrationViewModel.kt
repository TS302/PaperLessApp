package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.uiStates.RegistrationUiState
import com.tom.paperless.domain.useCases.LoginUserUseCase
import com.tom.paperless.domain.useCases.RegisterUserUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class RegistrationViewModel : ViewModel(), KoinComponent {

    private val registerUserUseCase: RegisterUserUseCase by inject()
    private val loginUserUseCase: LoginUserUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, RegistrationUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<RegistrationUiState> = _uiState.asStateFlow()


    fun onFirstnameChanged(newValue: String) {
        _uiState.update { it.copy(firstname = newValue.trim(), errorMessage = null, success = false) }
    }

    fun onLastnameChanged(newValue: String) {
        _uiState.update { it.copy(lastname = newValue.trim(), errorMessage = null, success = false) }
    }

    fun onEmailChanged(newValue: String) {
        _uiState.update { it.copy(email = newValue.trim(), errorMessage = null, success = false) }
    }

    fun onPasswordChanged(newValue: String) {
        _uiState.update { it.copy(password = newValue, errorMessage = null, success = false) }
    }

    fun onConfirmPasswordChanged(newValue: String) {
        _uiState.update { it.copy(confirmPassword = newValue, errorMessage = null, success = false) }
    }

    fun register() = viewModelScope.launch {
        val current = _uiState.value
        val registerResult = registerUserUseCase(
            firstName = current.firstname,
            lastName = current.lastname,
            emailAddress = current.email,
            plainPassword = current.password
        )

        if (registerResult.isSuccess) {
            val loginResult = loginUserUseCase(
                emailAddress = current.email,
                plainPassword = current.password
            )
            _uiState.update { prev ->
                loginResult.fold(
                    onSuccess = { prev.copy(success = true, errorMessage = null, password = "") },
                    onFailure = { e -> prev.copy(success = false, errorMessage = e.message) }
                )
            }
        } else {
            _uiState.update { prev ->
                prev.copy(success = false, errorMessage = registerResult.exceptionOrNull()?.message)
            }
        }
    }

    fun reset() {
        _uiState.update { RegistrationUiState() }
    }
}