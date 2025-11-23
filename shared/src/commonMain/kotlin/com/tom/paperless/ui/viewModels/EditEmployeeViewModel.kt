package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.uiStates.EditEmployeeUiState
import com.tom.paperless.domain.useCases.employeesUseCases.UpdateEmployeeUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject


class EditEmployeeViewModel : ViewModel(), KoinComponent {

    private lateinit var originalEmployee: Employee
    private val updateEmployee: UpdateEmployeeUseCase by inject()
    private val _uiState = MutableStateFlow(viewModelScope, EditEmployeeUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<EditEmployeeUiState> = _uiState.asStateFlow()

    fun setEmployee(employee: Employee) {
        originalEmployee = employee
        _uiState.value = buildInitialState(employee)
    }

    fun onNameChange(newName: String) = updateDraft(name = newName)

    fun onEmailChange(newEmail: String) = updateDraft(email = newEmail)

    fun onPhoneChange(newPhone: String) = updateDraft(phoneNumber = newPhone)

    fun reset() {
        if (!::originalEmployee.isInitialized) return
        _uiState.value = buildInitialState(originalEmployee)
    }

    fun save() {
        if (!::originalEmployee.isInitialized) return

        val currentState = _uiState.value

        if (!currentState.isValid || currentState.isSaving) return

        val employeeToSave = originalEmployee.copy(
            name = currentState.name.trim(),
            email = currentState.email.trim(),
            phoneNumber = currentState.phoneNumber.trim()
        )

        _uiState.update { it.copy(isSaving = true, errorMessage = null) }

        viewModelScope.launch {
            runCatching { updateEmployee(employeeToSave) }
                .onSuccess { savedEmployee ->
                    _uiState.value = buildInitialState(savedEmployee)
                }
                .onFailure { throwable ->
                    _uiState.update {
                        it.copy(
                            isSaving = false,
                            errorMessage = throwable.message
                        )
                    }
                }
        }
    }

    private fun buildInitialState(employee: Employee): EditEmployeeUiState {
        return EditEmployeeUiState(
            id = employee.id,
            name = employee.name,
            email = employee.email,
            phoneNumber = employee.phoneNumber,
            isSaving = false,
            isValid = validateInputs(employee.name, employee.email),
            hasChanges = false,
            errorMessage = null
        )
    }

    private fun updateDraft(
        name: String? = null,
        email: String? = null,
        phoneNumber: String? = null
    ) {
        _uiState.update { previous ->
            val newName = name ?: previous.name
            val newEmail = email ?: previous.email
            val newPhone = phoneNumber ?: previous.phoneNumber

            val hasChanges = if (::originalEmployee.isInitialized) {
                newName != originalEmployee.name ||
                        newEmail != originalEmployee.email ||
                        newPhone != originalEmployee.phoneNumber
            } else {
                true
            }

            previous.copy(
                name = newName,
                email = newEmail,
                phoneNumber = newPhone,
                isValid = validateInputs(newName, newEmail),
                hasChanges = hasChanges
            )
        }
    }

    private fun validateInputs(name: String, email: String): Boolean {
        if (name.trim().isEmpty()) return false
        if (email.isNotEmpty() && (!email.contains("@") || !email.contains("."))) {
            return false
        }
        return true
    }
}