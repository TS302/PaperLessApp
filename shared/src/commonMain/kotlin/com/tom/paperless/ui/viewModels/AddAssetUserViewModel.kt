package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.uiStates.AssetUserUiState
import com.tom.paperless.domain.useCases.employeesUseCases.AddAssetUserUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AddAssetUserViewModel() : ViewModel(), KoinComponent {

    private val addAssetUser: AddAssetUserUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, AssetUserUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AssetUserUiState> = _uiState.asStateFlow()

    fun setName(value: String) = _uiState.update { it.copy(name = value, errorMessage = null) }
    fun setEmail(value: String) = _uiState.update { it.copy(email = value, errorMessage = null) }
    fun setPhoneNumber(value: String) = _uiState.update { it.copy(phoneNumber = value, errorMessage = null) }

    fun submit() = viewModelScope.launch {
        val current = _uiState.value
        if(current.isSaving) return@launch
        _uiState.update { it.copy(isSaving = true, errorMessage = null) }

        try {
            val newAssetUser = AssetUser(
                id = Uuid.random(),
                name = current.name,
                email = current.email,
                phoneNumber = current.phoneNumber
            )
            addAssetUser(newAssetUser)
            _uiState.update { it.copy(isSaving = false, didSave = true) }

        } catch (t: Throwable) {
            _uiState.update { it.copy(isSaving = false, errorMessage = t.message ?: "Unbekannter Fehler!") }
        }
    }

    fun resetDidSave() = _uiState.update { it.copy(didSave = false) }
}