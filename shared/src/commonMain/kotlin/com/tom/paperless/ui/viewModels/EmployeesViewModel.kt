package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.uiStates.EmployeesUiState
import com.tom.paperless.domain.useCases.employeesUseCases.AddEmployeeUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.DeleteEmployeeUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.FilterEmployeesUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.GetAllEmployeesFlowUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.UpdateEmployeeUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class EmployeesViewModel() : ViewModel(), KoinComponent {

    private val getAllEmployeesFlow: GetAllEmployeesFlowUseCase by inject()
    private val addEmployee: AddEmployeeUseCase by inject()
    private val updateEmployee: UpdateEmployeeUseCase by inject()
    private val deleteEmployee: DeleteEmployeeUseCase by inject()
    private val filterEmployees: FilterEmployeesUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, EmployeesUiState.empty())
    @NativeCoroutinesState
    val uiState: StateFlow<EmployeesUiState> = _uiState.asStateFlow()

    private var lastAllEmployees: List<Employee> = emptyList()

    init {
        viewModelScope.launch {
            getAllEmployeesFlow().collectLatest { allEmployees ->
                lastAllEmployees = allEmployees

                val currentSearchText = _uiState.value.searchQueryText
                val filteredEmployees =
                    filterEmployees(allEmployees, currentSearchText)

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    items = filteredEmployees,
                    errorMessage = null
                )
            }
        }
    }

    fun setSearchQuery(newSearchText: String) {
        _uiState.value = _uiState.value.copy(searchQueryText = newSearchText)
        recomputeVisibleEmployees()
    }

    private fun recomputeVisibleEmployees() {
        val stateBefore = _uiState.value
        val filteredEmployees =
            filterEmployees(lastAllEmployees, stateBefore.searchQueryText)

        _uiState.value = stateBefore.copy(items = filteredEmployees)
    }

    fun add(employee: Employee) = viewModelScope.launch {
        runCatching { addEmployee(employee) }
            .onFailure { error ->
                _uiState.value = _uiState.value.copy(errorMessage = error.message)
            }
    }

    fun update(employee: Employee) = viewModelScope.launch {
        runCatching { updateEmployee(employee) }
            .onFailure { error ->
                _uiState.value = _uiState.value.copy(errorMessage = error.message)
            }
    }

    fun delete(employeeId: Uuid) = viewModelScope.launch {
        runCatching { deleteEmployee(employeeId) }
            .onFailure { error ->
                _uiState.value = _uiState.value.copy(errorMessage = error.message)
            }
    }

    fun setSearchQueryForIos(searchText: String) = setSearchQuery(searchText)

}