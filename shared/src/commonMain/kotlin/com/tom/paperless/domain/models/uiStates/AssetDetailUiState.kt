package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagStatus

data class AssetDetailUiState(
    val asset: NfcTaggable? = null,
    val isLoading: Boolean = false,
    val name: String = "",
    val status: TagStatus? = null,
    val currentAssignedEmployee: Employee? = null,
    val currentAssigneeId: String? = null,
    val currentAssigneeName: String? = null,
    val currentAssignmentNote: String? = null,
    val lastAssignees: List<Employee> = emptyList(),
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val errorMessage: String? = null,
    val operationSucceeded: Boolean = false,
    val isDirty: Boolean = false,
    val isEditing: Boolean = false,
    val brand: String? = null,
    val serialNumber: String? = null,
    val lastAssignments: List<Assignment> = emptyList()
) {
    companion object Companion {
        fun empty() = AssetDetailUiState()
    }
}
