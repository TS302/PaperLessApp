package com.tom.paperless.domain.models.uiStates

data class RegistrationUiState(
    val firstname: String = "",
    val lastname: String = "",
    val email: String = "",
    val password: String = "",
    val confirmPassword: String = "",
    val success: Boolean = false,
    val errorMessage: String? = null,
    val isLoading: Boolean = false
)