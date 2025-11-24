package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.uiStates.AddVehicleUiState
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AddVehicleViewModel() : ViewModel(), KoinComponent {

    private val addNfcTaggable: AddNfcTaggableUseCase by inject()
    private val _uiState = MutableStateFlow(viewModelScope, AddVehicleUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AddVehicleUiState> = _uiState.asStateFlow()

    fun setName(value: String) = _uiState.update { it.copy(name = value, errorMessage = null) }
    fun setPlate(value: String) = _uiState.update { it.copy(plate = value, errorMessage = null) }
    fun setBrand(value: String) = _uiState.update { it.copy(brand = value, errorMessage = null) }

    fun submit() = viewModelScope.launch {
        val state = _uiState.value
        if (state.isSaving) return@launch
        if (state.name.trim().isEmpty()) {
            _uiState.update { it.copy(errorMessage = "Name darf nicht leer sein.") }
            return@launch
        }
        _uiState.update { it.copy(isSaving = true, errorMessage = null) }

        runCatching {
            val newItem = Vehicle(
                id = Uuid.random(),
                name = state.name.trim(),
                brand = state.brand.trim().ifEmpty { null },
                plate = state.plate.trim().ifEmpty { null },
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