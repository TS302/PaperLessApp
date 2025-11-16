package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.uiStates.AssignAssetUiState
import com.tom.paperless.domain.useCases.assetsUseCases.AssignAssetToEmployeeUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.ReturnAssetUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssignAssetViewModel : ViewModel(), KoinComponent {

    private val employeeRepository: EmployeeRepository by inject()
    private val nfcTaggableRepository: NfcTaggableRepository by inject()
    private val assignmentRepository: AssignmentRepository by inject()
    private val assignAssetToEmployeeUseCase: AssignAssetToEmployeeUseCase by inject()
    private val returnAssetUseCase: ReturnAssetUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, AssignAssetUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AssignAssetUiState> = _uiState.asStateFlow()

    private var itemId: Uuid? = null


    fun attach(itemIdString: String) {
        val parsed = runCatching { Uuid.parse(itemIdString) }.getOrNull() ?: run {
            _uiState.value = _uiState.value.copy(errorMessage = "Ungültige Item-ID.")
            return
        }
        if (itemId == parsed) return
        itemId = parsed

        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, errorMessage = null)
            try {
                val employees = employeeRepository.getAll()
                val asset = nfcTaggableRepository.getById(parsed)
                val currentAssignee: Employee? = assignmentRepository.currentAssigneeOf(parsed)
                val lastAssignees: List<Employee> = assignmentRepository.lastAssigneesOf(parsed)

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    employees = employees,
                    currentAssigneeId = currentAssignee?.id,
                    currentAssigneeName = currentAssignee?.name,
                    assetDisplayName = asset?.name ?: "Asset",
                    lastAssignees = lastAssignees
                )
            } catch (t: Throwable) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    errorMessage = t.message ?: "Fehler beim Laden."
                )
            }
        }
    }

    fun assignToEmployee(employeeId: Uuid) {
        val assetId = itemId ?: run {
            _uiState.value = _uiState.value.copy(errorMessage = "Kein Asset ausgewählt.")
            return
        }
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isLoading = true,
                errorMessage = null,
                didAssignSuccessfully = false
            )
            try {
                assignAssetToEmployeeUseCase(employeeId = employeeId, assetId = assetId)
                val employee = employeeRepository.getById(employeeId)
                val lastAssignees = assignmentRepository.lastAssigneesOf(assetId, limit = 3)
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    didAssignSuccessfully = true,
                    currentAssigneeId = employeeId,
                    currentAssigneeName = employee?.name,
                    lastAssignees = lastAssignees
                )
            } catch (t: Throwable) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    errorMessage = t.message ?: "Unbekannter Fehler beim Zuweisen."
                )
            }
        }
    }

    fun reassignToEmployee(employeeId: Uuid) {
        val assetId = itemId ?: run {
            _uiState.value = _uiState.value.copy(errorMessage = "Kein Asset ausgewählt.")
            return
        }
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, errorMessage = null)
            try {
                returnAssetUseCase(assetId)
                assignAssetToEmployeeUseCase(employeeId = employeeId, assetId = assetId)
                val employee = employeeRepository.getById(employeeId)
                val lastAssignees = assignmentRepository.lastAssigneesOf(assetId, limit = 3)

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    didAssignSuccessfully = true,
                    currentAssigneeId = employeeId,
                    currentAssigneeName = employee?.name,
                    lastAssignees = lastAssignees
                )
            } catch (t: Throwable) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    errorMessage = t.message ?: "Fehler beim Neu-Zuweisen."
                )
            }
        }
    }

    fun resetSuccessFlag() {
        _uiState.value = _uiState.value.copy(didAssignSuccessfully = false)
    }

    fun onEmployeeTapped(employee: Employee) {
        val state = _uiState.value
        val currentId = state.currentAssigneeId

        if (currentId == null) {
            _uiState.value = state.copy(
                selectedEmployeeId = employee.id,
                dialogType = AssignAssetUiState.DialogType.CONFIRM_ASSIGN
            )
        } else if (currentId == employee.id) {
            _uiState.value = state.copy(
                selectedEmployeeId = null,
                dialogType = null
            )
        } else {
            _uiState.value = state.copy(
                selectedEmployeeId = employee.id,
                dialogType = AssignAssetUiState.DialogType.CONFIRM_REASSIGN
            )
        }
    }

    fun cancelDialog() {
        _uiState.value = _uiState.value.copy(
            selectedEmployeeId = null,
            dialogType = null
        )
    }

    fun confirmAssign() {
        val employeeId = _uiState.value.selectedEmployeeId ?: return
        cancelDialog()
        assignToEmployee(employeeId)
    }

    fun confirmReassign() {
        val employeeId = _uiState.value.selectedEmployeeId ?: return
        cancelDialog()
        reassignToEmployee(employeeId)
    }

}