package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.uiStates.AddKeyUiState
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlin.uuid.Uuid

class AddKeyViewModel(
    private val addNfcTaggable: AddNfcTaggableUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(viewModelScope, AddKeyUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AddKeyUiState> = _uiState.asStateFlow()

    fun setName(value: String) = _uiState.update { it.copy(name = value, errorMessage = null) }

    fun submit() = viewModelScope.launch {
        val s = _uiState.value
        if (s.isSaving) return@launch
        if (s.name.trim().isEmpty()) {
            _uiState.update { it.copy(errorMessage = "Name darf nicht leer sein.") }
            return@launch
        }
        _uiState.update { it.copy(isSaving = true, errorMessage = null) }

        runCatching {
            val newItem = KeyRing(
                id = Uuid.random(),
                name = s.name.trim(),
                tagStatus = TagStatus.available
            )
            addNfcTaggable(newItem)
        }.onSuccess {
            _uiState.update { it.copy(isSaving = false, didSave = true) }
        }.onFailure { e ->
            _uiState.update { it.copy(isSaving = false, errorMessage = e.message ?: "Unbekannter Fehler") }
        }
    }

    fun resetDidSave() = _uiState.update { it.copy(didSave = false) }
}