package com.tom.paperless.domain.models.uiStates

data class AddVehicleUiState(
    val name: String = "",
    val plate: String = "",
    val isSaving: Boolean = false,
    val didSave: Boolean = false,
    val errorMessage: String? = null
)