package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.Employee

data class EmployeeDetailUiState(
    val isLoading: Boolean = false,
    val employee: Employee? = null,

    val draftName: String = "",
    val draftEmail: String = "",
    val draftPhone: String = "",

    val isEditing: Boolean = false,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val errorMessage: String? = null,
    val operationSucceeded: Boolean = false,
    val isValid: Boolean = false,
    val hasChanges: Boolean = false
) {
    companion object {
        fun empty() = EmployeeDetailUiState()
    }
}