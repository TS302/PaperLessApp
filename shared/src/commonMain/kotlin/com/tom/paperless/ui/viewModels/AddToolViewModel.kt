package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.uiStates.AddToolUiState
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AddToolViewModel() : ViewModel(), KoinComponent {

    private val addNfcTaggable: AddNfcTaggableUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, AddToolUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<AddToolUiState> = _uiState.asStateFlow()

    fun setName(value: String) = _uiState.update { it.copy(name = value, errorMessage = null) }
    fun setSerialNumber(value: String) = _uiState.update { it.copy(serialNumber = value, errorMessage = null) }

    fun submit() = viewModelScope.launch {
        val s = _uiState.value
        if (s.isSaving) return@launch
        if (s.name.trim().isEmpty()) {
            _uiState.update { it.copy(errorMessage = "Name darf nicht leer sein.") }
            return@launch
        }
        _uiState.update { it.copy(isSaving = true, errorMessage = null) }

        runCatching {
            val newItem = Tool(
                id = Uuid.random(),
                name = s.name.trim(),
                serialNumber = s.serialNumber.trim().ifEmpty { null },
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