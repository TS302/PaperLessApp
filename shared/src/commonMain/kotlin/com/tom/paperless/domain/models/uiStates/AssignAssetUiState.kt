package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.Employee
import kotlin.uuid.Uuid

data class AssignAssetUiState(
    val isLoading: Boolean = false,
    val employees: List<Employee> = emptyList(),
    val selectedEmployeeId: Uuid? = null,
    val errorMessage: String? = null,
    val didAssignSuccessfully: Boolean = false
)