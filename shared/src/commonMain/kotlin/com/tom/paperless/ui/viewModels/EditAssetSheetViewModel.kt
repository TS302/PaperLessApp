package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.mappers.withName
import com.tom.paperless.domain.mappers.withStatus
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.uiStates.EditAssetUiState
import com.tom.paperless.domain.useCases.GetNfcTaggableByIdUseCase
import com.tom.paperless.domain.useCases.SaveNfcTaggableUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class EditAssetSheetViewModel() : ViewModel(), KoinComponent {

    private val getTagById: GetNfcTaggableByIdUseCase by inject()
    private val saveAsset: SaveNfcTaggableUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, EditAssetUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<EditAssetUiState> = _uiState.asStateFlow()

    fun start(asset: NfcTaggable, refresh: Boolean = false) {
        _uiState.value = _uiState.value.copy(
            asset = asset,
            isLoading = false,
            errorMessage = null,
            operationSucceeded = false,
            name = asset.name,
            status = asset.tagStatus,
            brand = (asset as? Tool)?.brand ?: (asset as? Vehicle)?.brand,
            plate = (asset as? Vehicle)?.plate,
            serialNumber = (asset as? Tool)?.serialNumber,
            isDirty = false,
            isEditing = true
        )
    }

    fun reload(assetId: Uuid) {
        loadByIdInternal(assetId)
    }

    private fun loadByIdInternal(id: Uuid) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isLoading = true,
                errorMessage = null,
                operationSucceeded = false
            )
            runCatching { getTagById(id) }
                .onSuccess { loadAsset ->
                    val currentState = _uiState.value
                    _uiState.value = when {
                        loadAsset == null ->
                            currentState.copy(
                                isLoading = false,
                                errorMessage = "Item nicht gefunden."
                            )
                        currentState.isDirty ->
                            currentState.copy(
                                isLoading = false
                            )
                        else ->
                            currentState.copy(
                                asset = loadAsset,
                                isLoading = false,
                                status = loadAsset.tagStatus,
                            )
                    }
                }
                .onFailure { error ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        errorMessage = error.message
                    )
                }
        }
    }

    fun allStatuees(): List<TagStatus> =
        try { TagStatus.entries } catch (_: Throwable) { TagStatus.values().toList() }

    fun saveCurrentItem() {
        val assetToSave = _uiState.value.asset ?: return
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isSaving = true,
                errorMessage = null,
                operationSucceeded = false
            )
            runCatching { saveAsset(assetToSave) }
                .onSuccess { saveAsset ->
                    _uiState.value = _uiState.value.copy(
                        asset = saveAsset,
                        isSaving = false,
                        operationSucceeded = true,
                        isDirty = false,
                        name = saveAsset.name,
                        status = saveAsset.tagStatus
                    )
                }
                .onFailure { error ->
                    _uiState.value = _uiState.value.copy(
                        isSaving = false,
                        errorMessage = error.message
                    )
                }
        }
    }

    fun cleanMessage() {
        _uiState.value = _uiState.value.copy(
            errorMessage = null,
            operationSucceeded = false
        )
    }

    fun setNameinState(newName: String) {
        val currentName = _uiState.value.asset ?: return
        _uiState.value = _uiState.value.copy(
            asset = currentName.withName(newName),
            name = newName,
            isDirty = true
        )
    }

    fun setStatusInState(newStatus: TagStatus) {
        val currentStatus = _uiState.value.asset ?: return
        _uiState.value = _uiState.value.copy(
            asset = currentStatus.withStatus(newStatus),
            status = newStatus,
            isDirty = true
        )
    }

    fun setBrandInState(newBrand: String) {
        val current = _uiState.value.asset ?: return
        val updated = when (current) {
            is Tool -> current.copy(brand = newBrand)
            is Vehicle -> current.copy(brand = newBrand)
            else -> current
        }
        _uiState.value = _uiState.value.copy(
            asset = updated,
            brand = newBrand,
            isDirty = true
        )
    }

    fun setPlateInState(newPlate: String) {
        val current = _uiState.value.asset ?: return
        val updated = when (current) {
            is Vehicle -> current.copy(plate = newPlate)
            else -> current
        }
        _uiState.value = _uiState.value.copy(
            asset = updated,
            plate = newPlate,
            isDirty = true
        )
    }

    fun setSerialNumberInState(newSerial: String) {
        val current = _uiState.value.asset ?: return
        val updated = when (current) {
            is Tool -> current.copy(serialNumber = newSerial)
            else -> current
        }
        _uiState.value = _uiState.value.copy(
            asset = updated,
            serialNumber = newSerial,
            isDirty = true
        )
    }
}