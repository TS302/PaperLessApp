package com.tom.paperless.domain.models.uiStates

data class LoginUiState(
    val email: String = "",
    val password: String = "",
    val success: Boolean = false,
    val errorMessage: String? = null
)