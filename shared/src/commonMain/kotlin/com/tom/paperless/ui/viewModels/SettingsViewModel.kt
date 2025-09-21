package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.tom.paperless.domain.models.uiStates.SettingsUiState
import com.tom.paperless.domain.useCases.LogoutUserUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update

class SettingsViewModel(
    private val logoutUserUseCase: LogoutUserUseCase
) : ViewModel() {

    private val _uiStateInternal = MutableStateFlow(SettingsUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<SettingsUiState> = _uiStateInternal

    fun logout() {
        logoutUserUseCase()
        _uiStateInternal.update { SettingsUiState(logoutSuccess = true, errorMessage = null) }
    }

    fun reset() {
        _uiStateInternal.value = SettingsUiState()
    }
}