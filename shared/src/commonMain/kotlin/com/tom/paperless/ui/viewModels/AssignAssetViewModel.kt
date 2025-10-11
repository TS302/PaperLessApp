package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.uiStates.AssignAssetUiState
import com.tom.paperless.domain.useCases.assetsUseCases.AssignAssetsToEmployeeUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlin.uuid.Uuid

class AssignAssetViewModel(
    private val itemId: Uuid,
    private val employeeRepository: EmployeeRepository,
    private val assignAssetsToEmployeeUseCase: AssignAssetsToEmployeeUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(viewModelScope, AssignAssetUiState(isLoading = true))

    @NativeCoroutinesState
    val uiState: StateFlow<AssignAssetUiState> = _uiState.asStateFlow()

    init {
        loadEmployees()
    }

    fun loadEmployees() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, errorMessage = null)
            runCatching { employeeRepository.getAll() }
                .onSuccess { list ->
                    _uiState.value = AssignAssetUiState(
                        isLoading = false,
                        employees = list,
                        selectedEmployeeId = null,
                        errorMessage = null,
                        didAssignSuccessfully = false
                    )
                }
                .onFailure { e ->
                    _uiState.value = _uiState.value.copy(isLoading = false, errorMessage = e.message)
                }
        }
    }

    fun selectEmployee(employeeId: Uuid) {
        _uiState.value = _uiState.value.copy(selectedEmployeeId = employeeId)
    }

    fun assignSelectedEmployee() {
        val employeeId = _uiState.value.selectedEmployeeId ?: return
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, errorMessage = null, didAssignSuccessfully = false)
            runCatching {
                assignAssetsToEmployeeUseCase(employeeId, listOf(itemId))
            }.onSuccess {
                _uiState.value = _uiState.value.copy(isLoading = false, didAssignSuccessfully = true)
            }.onFailure { e ->
                _uiState.value = _uiState.value.copy(isLoading = false, errorMessage = e.message)
            }
        }
    }

    fun resetSuccessFlag() {
        _uiState.value = _uiState.value.copy(didAssignSuccessfully = false)
    }
}