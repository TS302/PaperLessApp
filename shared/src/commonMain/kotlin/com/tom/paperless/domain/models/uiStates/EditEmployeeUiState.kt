package com.tom.paperless.domain.models.uiStates

import kotlin.uuid.Uuid

data class EditEmployeeUiState(
    val id: Uuid = Uuid.random(),
    val name: String = "",
    val email: String = "",
    val phoneNumber: String = "",

    val isSaving: Boolean = false,
    val isValid: Boolean = false,
    val hasChanges: Boolean = false,
    val errorMessage: String? = null
)
