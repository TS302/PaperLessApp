package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.uiStates.EmployeeDetailUiState
import com.tom.paperless.domain.useCases.assetsUseCases.GetAssetsOfEmployeeUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.DeleteEmployeeUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.GetEmployeeByIdUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.UpdateEmployeeUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlin.uuid.Uuid
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.ui.AssignedItemUi
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.time.ExperimentalTime

class EmployeeDetailViewModel() : ViewModel(), KoinComponent {

    private val getEmployeeById: GetEmployeeByIdUseCase by inject()
    private val updateEmployee: UpdateEmployeeUseCase by inject()
    private val deleteEmployee: DeleteEmployeeUseCase by inject()
    private val getAssetsOfEmployee: GetAssetsOfEmployeeUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, EmployeeDetailUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<EmployeeDetailUiState> = _uiState.asStateFlow()


    fun load(employeeId: Uuid) {
        _uiState.update { state -> state.copy(isLoading = true, errorMessage = null) }

        viewModelScope.launch {
            runCatching { getEmployeeById(employeeId) }
                .onSuccess { loadedEmployee ->
                    if (loadedEmployee == null) {
                        _uiState.update { state -> state.copy(isLoading = false, employee = null) }
                    } else {
                        _uiState.update { state ->
                            state.copy(
                                isLoading = false,
                                employee = loadedEmployee,
                                draftName = loadedEmployee.name,
                                draftEmail = loadedEmployee.email,
                                draftPhone = loadedEmployee.phoneNumber,
                                isEditing = false,
                                isValid = validateInputs(loadedEmployee.name, loadedEmployee.email),
                                hasChanges = false
                            )
                        }
                        refreshAssignedItems()
                    }
                }
                .onFailure { throwable ->
                    _uiState.update { state -> state.copy(isLoading = false, errorMessage = throwable.message) }
                }
        }
    }

    fun beginEdit() {
        val currentEmployee = _uiState.value.employee ?: return
        _uiState.update { state ->
            state.copy(
                isEditing = true,
                draftName = currentEmployee.name,
                draftEmail = currentEmployee.email,
                draftPhone = currentEmployee.phoneNumber,
                isValid = validateInputs(currentEmployee.name, currentEmployee.email),
                hasChanges = false
            )
        }
    }

    fun discardChanges() {
        val currentEmployee = _uiState.value.employee ?: return
        _uiState.update { state ->
            state.copy(
                isEditing = false,
                draftName = currentEmployee.name,
                draftEmail = currentEmployee.email,
                draftPhone = currentEmployee.phoneNumber,
                isValid = validateInputs(currentEmployee.name, currentEmployee.email),
                hasChanges = false
            )
        }
    }

    fun onNameChange(newName: String)   = updateDraft(newDraftName = newName)
    fun onEmailChange(newEmail: String) = updateDraft(newDraftEmail = newEmail)
    fun onPhoneChange(newPhone: String) = updateDraft(newDraftPhone = newPhone)

    private fun updateDraft(
        newDraftName: String? = null,
        newDraftEmail: String? = null,
        newDraftPhone: String? = null
    ) {
        _uiState.update { previousState ->
            val draftName = newDraftName ?: previousState.draftName
            val draftEmail = newDraftEmail ?: previousState.draftEmail
            val draftPhone = newDraftPhone ?: previousState.draftPhone

            val originalEmployee = previousState.employee
            val hasAnyFieldChanged = originalEmployee?.let {
                it.name != draftName || it.email != draftEmail || it.phoneNumber != draftPhone
            } ?: false

            previousState.copy(
                draftName = draftName,
                draftEmail = draftEmail,
                draftPhone = draftPhone,
                isValid = validateInputs(draftName, draftEmail),
                hasChanges = hasAnyFieldChanged
            )
        }
    }

    private fun validateInputs(nameValue: String, emailValue: String): Boolean {
        if (nameValue.trim().isEmpty()) return false
        if (emailValue.isNotEmpty() && (!emailValue.contains("@") || !emailValue.contains("."))) return false
        return true
    }

    fun load(idString: String) {
        val id = runCatching { Uuid.parse(idString) }.getOrNull() ?: return
        load(id)
    }

    fun save() {
        val currentState = _uiState.value
        val currentEmployee = currentState.employee ?: return
        if (!currentState.isValid || !currentState.hasChanges) return

        val employeeToSave = currentEmployee.copy(
            name = currentState.draftName.trim(),
            email = currentState.draftEmail.trim(),
            phoneNumber = currentState.draftPhone.trim()
        )

        _uiState.update { it.copy(isSaving = true, errorMessage = null) }

        viewModelScope.launch {
            runCatching { updateEmployee(employeeToSave) }
                .onSuccess { savedEmployee ->
                    _uiState.update {
                        it.copy(
                            employee = savedEmployee,
                            isSaving = false,
                            isEditing = false,
                            draftName = savedEmployee.name,
                            draftEmail = savedEmployee.email,
                            draftPhone = savedEmployee.phoneNumber,
                            hasChanges = false,
                            isValid = validateInputs(savedEmployee.name, savedEmployee.email)
                        )
                    }
                }
                .onFailure { throwable ->
                    _uiState.update { it.copy(isSaving = false, errorMessage = throwable.message) }
                }
        }
    }

    fun delete() {
        val currentEmployee = _uiState.value.employee ?: return
        _uiState.update { it.copy(isSaving = true, errorMessage = null) }

        viewModelScope.launch {
            runCatching { deleteEmployee(currentEmployee.id) }
                .onSuccess {
                    _uiState.value = EmployeeDetailUiState.empty() // zurücksetzen
                }
                .onFailure { throwable ->
                    _uiState.update { it.copy(isSaving = false, errorMessage = throwable.message) }
                }
        }
    }

    @OptIn(ExperimentalTime::class)
    fun refreshAssignedItems() {
        val employee = _uiState.value.employee ?: return
        viewModelScope.launch {
            val assets = runCatching { getAssetsOfEmployee(employee.id) }.getOrElse { emptyList() }

            val itemsUi = assets.map { nfcTag ->
                when (nfcTag) {
                    is Vehicle -> AssignedItemUi(
                        id = nfcTag.id.toString(),
                        displayName = nfcTag.name,
                        type = "vehicle",
                        subtype = null,
                        code = nfcTag.plate,
                        statusText = nfcTag.tagStatus.name,
                        status = nfcTag.tagStatus

                    )
                    is Tool -> AssignedItemUi(
                        id = nfcTag.id.toString(),
                        displayName = nfcTag.name,
                        type = "tool",
                        subtype = null,
                        code = nfcTag.serialNumber,
                        statusText = nfcTag.tagStatus.name,
                        status = nfcTag.tagStatus

                    )
                    is KeyRing -> AssignedItemUi(
                        id = nfcTag.id.toString(),
                        displayName = nfcTag.name,
                        type = "key",
                        subtype = null,
                        code = null,
                        statusText = nfcTag.tagStatus.name,
                        status = nfcTag.tagStatus

                    )
                    else -> AssignedItemUi(
                        id = nfcTag.id.toString(),
                        displayName = nfcTag.name,
                        type = nfcTag.targetType.name.lowercase(),
                        subtype = null,
                        code = null,
                        statusText = nfcTag.tagStatus.name,
                        status = nfcTag.tagStatus
                    )
                }
            }

            _uiState.update { it.copy(assignedItems = itemsUi) }
        }
    }
}