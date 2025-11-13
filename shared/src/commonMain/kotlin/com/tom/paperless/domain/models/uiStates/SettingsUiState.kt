package com.tom.paperless.domain.models.uiStates

data class SettingsUiState(
    val logoutSuccess: Boolean = false,
    val errorMessage: String? = null,
    val isLoading: Boolean = false
)
