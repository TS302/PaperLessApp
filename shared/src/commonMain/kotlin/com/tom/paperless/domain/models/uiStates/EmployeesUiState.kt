package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.Employee

data class EmployeesUiState(
    val items: List<Employee> = emptyList(),
    val searchQueryText: String = "",
    val isLoading: Boolean = false,
    val errorMessage: String? = null
) {
    companion object { fun empty() = EmployeesUiState() }
}