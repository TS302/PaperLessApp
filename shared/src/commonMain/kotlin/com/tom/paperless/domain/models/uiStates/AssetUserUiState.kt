package com.tom.paperless.domain.models.uiStates

data class AssetUserUiState (
    val name: String = "",
    val email: String = "",
    val phoneNumber: String = "",
    val isSaving: Boolean = false,
    val errorMessage: String? = null,
    val didSave: Boolean = false
)


