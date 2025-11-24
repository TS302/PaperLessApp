package com.tom.paperless.domain.models.uiStates

data class AddToolUiState(
    val name: String = "",
    val brand: String = "",
    val serialNumber: String = "",
    val isSaving: Boolean = false,
    val didSave: Boolean = false,
    val errorMessage: String? = null
)