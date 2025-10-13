package com.tom.paperless.domain.models.uiStates

data class AddKeyUiState(
    val name: String = "",
    val isSaving: Boolean = false,
    val didSave: Boolean = false,
    val errorMessage: String? = null
)