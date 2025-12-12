package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.uiStates.EditAssetUserUiState
import com.tom.paperless.domain.useCases.UpdateAssetUserUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject


class EditAssetUserViewModel : ViewModel(), KoinComponent {

    private lateinit var originalAssetUser: AssetUser
    private val updateEmployee: UpdateAssetUserUseCase by inject()
    private val _uiState = MutableStateFlow(viewModelScope, EditAssetUserUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<EditAssetUserUiState> = _uiState.asStateFlow()

    fun setEmployee(assetUser: AssetUser) {
        originalAssetUser = assetUser
        _uiState.value = buildInitialState(assetUser)
    }

    fun onNameChange(newName: String) = updateDraft(name = newName)

    fun onEmailChange(newEmail: String) = updateDraft(email = newEmail)

    fun onPhoneChange(newPhone: String) = updateDraft(phoneNumber = newPhone)

    fun reset() {
        if (!::originalAssetUser.isInitialized) return
        _uiState.value = buildInitialState(originalAssetUser)
    }

    fun save() {
        if (!::originalAssetUser.isInitialized) return

        val currentState = _uiState.value

        if (!currentState.isValid || currentState.isSaving) return

        val employeeToSave = originalAssetUser.copy(
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

    private fun buildInitialState(assetUser: AssetUser): EditAssetUserUiState {
        return EditAssetUserUiState(
            id = assetUser.id,
            name = assetUser.name,
            email = assetUser.email,
            phoneNumber = assetUser.phoneNumber,
            isSaving = false,
            isValid = validateInputs(assetUser.name, assetUser.email),
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

            val hasChanges = if (::originalAssetUser.isInitialized) {
                newName != originalAssetUser.name ||
                        newEmail != originalAssetUser.email ||
                        newPhone != originalAssetUser.phoneNumber
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