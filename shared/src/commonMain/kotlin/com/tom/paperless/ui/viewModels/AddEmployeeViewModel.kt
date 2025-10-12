package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.uiStates.AddEmployeeUiState
import com.tom.paperless.domain.useCases.employeesUseCases.AddEmployeeUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlin.uuid.Uuid

class AddEmployeeViewModel(
    private val addEmployee: AddEmployeeUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(viewModelScope, AddEmployeeUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AddEmployeeUiState> = _uiState.asStateFlow()

    fun setName(value: String) = _uiState.update { it.copy(name = value, errorMessage = null) }
    fun setEmail(value: String) = _uiState.update { it.copy(email = value, errorMessage = null) }
    fun setPhoneNumber(value: String) = _uiState.update { it.copy(phoneNumber = value, errorMessage = null) }

    fun submit() = viewModelScope.launch {
        val current = _uiState.value
        if(current.isSaving) return@launch
        _uiState.update { it.copy(isSaving = true, errorMessage = null) }

        try {
            val newEmployee = Employee(
                id = Uuid.random(),
                name = current.name,
                email = current.email,
                phoneNumber = current.phoneNumber
            )
            addEmployee(newEmployee)
            _uiState.update { it.copy(isSaving = false, didSave = true) }

        } catch (t: Throwable) {
            _uiState.update { it.copy(isSaving = false, errorMessage = t.message ?: "Unbekannter Fehler!") }
        }
    }

    fun resetDidSave() = _uiState.update { it.copy(didSave = false) }
}