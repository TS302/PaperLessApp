package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.uiStates.EmployeesUiState
import com.tom.paperless.domain.useCases.AddEmployeeUseCase
import com.tom.paperless.domain.useCases.DeleteEmployeeUseCase
import com.tom.paperless.domain.useCases.FilterEmployeesUseCase
import com.tom.paperless.domain.useCases.GetAllEmployeesFlowUseCase
import com.tom.paperless.domain.useCases.UpdateEmployeeUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlin.uuid.Uuid

class EmployeesViewModel(
    private val getAllEmployeesFlow: GetAllEmployeesFlowUseCase,
    private val addEmployee: AddEmployeeUseCase,
    private val updateEmployee: UpdateEmployeeUseCase,
    private val deleteEmployee: DeleteEmployeeUseCase,
    private val filterEmployees: FilterEmployeesUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(EmployeesUiState.empty())
    @NativeCoroutinesState
    val uiState: StateFlow<EmployeesUiState> = _uiState

    init {
        viewModelScope.launch {
            getAllEmployeesFlow().collectLatest { all ->
                val current = _uiState.value
                val visible = filterEmployees(all, current.searchQueryText)
                _uiState.value = current.copy(items = visible, isLoading = false)
            }
        }
    }

    fun setSearchQuery(newValue: String) {
        val current = _uiState.value
        _uiState.value = current.copy(searchQueryText = newValue)
        recomputeVisible()
    }

    private fun recomputeVisible() = viewModelScope.launch {
        _uiState.value = _uiState.value.copy(isLoading = true)
        val snapshot = getAllEmployeesFlow().value
        val st = _uiState.value
        _uiState.value = st.copy(items = filterEmployees(snapshot, st.searchQueryText), isLoading = false)
    }

    // CRUD
    fun add(item: Employee) = viewModelScope.launch {
        runCatching { addEmployee(item) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    fun update(item: Employee) = viewModelScope.launch {
        runCatching { updateEmployee(item) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    fun delete(id: Uuid) = viewModelScope.launch {
        runCatching { deleteEmployee(id) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    fun setSearchQueryForIos(queryText: String) = setSearchQuery(queryText)

}