package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.uiStates.ItemDetailUiState
import com.tom.paperless.domain.useCases.DeleteNfcTaggableUseCase
import com.tom.paperless.domain.useCases.GetNfcTaggableByIdUseCase
import com.tom.paperless.domain.useCases.SaveNfcTaggableUseCase
import com.tom.paperless.domain.mappers.withName
import com.tom.paperless.domain.mappers.withStatus
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlin.uuid.Uuid

class ItemDetailViewModel(
    private val getTagById: GetNfcTaggableByIdUseCase,
    private val saveTag: SaveNfcTaggableUseCase,
    private val deleteTag: DeleteNfcTaggableUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(viewModelScope, ItemDetailUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<ItemDetailUiState> = _uiState.asStateFlow()

    fun hydrate(item: NfcTaggable) {
        _uiState.value = _uiState.value.copy(
            item = item,
            isLoading = false,
            errorMessage = null,
            operationSucceeded = false
        )
    }

    fun start(item: NfcTaggable, refresh: Boolean = true) {
        hydrate(item)
        if (refresh) loadByIdInternal(item.id)
    }

    fun load(id: Uuid) = loadByIdInternal(id)

    private fun loadByIdInternal(id: Uuid) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isLoading = true,
                errorMessage = null,
                operationSucceeded = false
            )
            runCatching { getTagById(id) }
                .onSuccess { loadedItem ->
                    val currentState = _uiState.value
                    _uiState.value = when {
                        loadedItem == null ->
                            currentState.copy(isLoading = false, errorMessage = "Item nicht gefunden.")
                        currentState.isEditing || currentState.isDirty ->
                            currentState.copy(isLoading = false)
                        else ->
                            currentState.copy(item = loadedItem, isLoading = false)
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

    fun setEditing(active: Boolean) {
        _uiState.value = _uiState.value.copy(isEditing = active)
    }

    fun setNameInState(newName: String) {
        val current = _uiState.value.item ?: return
        _uiState.value = _uiState.value.copy(
            item = current.withName(newName),
            isDirty = true
        )
    }

    fun setStatusInState(newStatus: TagStatus) {
        val current = _uiState.value.item ?: return
        _uiState.value = _uiState.value.copy(
            item = current.withStatus(newStatus),
            isDirty = true
        )
    }

    fun allStatuses(): List<TagStatus> =
        try { TagStatus.entries } catch (_: Throwable) { TagStatus.values().toList() }

    fun saveCurrentItem() {
        val itemToSave = _uiState.value.item ?: return
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isSaving = true,
                errorMessage = null,
                operationSucceeded = false
            )
            runCatching { saveTag(itemToSave) }
                .onSuccess { savedItem ->
                    _uiState.value = _uiState.value.copy(
                        item = savedItem,
                        isSaving = false,
                        operationSucceeded = true,
                        isDirty = false
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

    fun deleteItem(id: Uuid) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isDeleting = true,
                errorMessage = null,
                operationSucceeded = false
            )
            runCatching { deleteTag(id) }
                .onSuccess { wasDeleted ->
                    _uiState.value = if (wasDeleted) {
                        _uiState.value.copy(
                            item = null,
                            isDeleting = false,
                            operationSucceeded = true
                        )
                    } else {
                        _uiState.value.copy(
                            isDeleting = false,
                            errorMessage = "Löschen fehlgeschlagen."
                        )
                    }
                }
                .onFailure { error ->
                    _uiState.value = _uiState.value.copy(
                        isDeleting = false,
                        errorMessage = error.message
                    )
                }
        }
    }

    fun clearMessage() {
        _uiState.value = _uiState.value.copy(
            errorMessage = null,
            operationSucceeded = false
        )
    }
}