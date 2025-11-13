package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.uiStates.SettingsUiState
import com.tom.paperless.domain.useCases.LogoutUserUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class SettingsViewModel : ViewModel(), KoinComponent {

    private val logoutUserUseCase: LogoutUserUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, SettingsUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<SettingsUiState> = _uiState

    fun logout() = viewModelScope.launch {
        val result = runCatching { logoutUserUseCase() }
        _uiState.update { prev ->
            result.fold(
                onSuccess = { prev.copy(logoutSuccess = true, errorMessage = null) },
                onFailure = { e -> prev.copy(logoutSuccess = false, errorMessage = e.message) }
            )
        }
    }

    fun reset() {
        _uiState.update { SettingsUiState() }
    }
}