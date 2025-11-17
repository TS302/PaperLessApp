package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.uiStates.AssetDetailUiState
import com.tom.paperless.domain.useCases.DeleteNfcTaggableUseCase
import com.tom.paperless.domain.useCases.GetNfcTaggableByIdUseCase
import com.tom.paperless.domain.useCases.SaveNfcTaggableUseCase
import com.tom.paperless.domain.mappers.withName
import com.tom.paperless.domain.mappers.withStatus
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssetDetailViewModel() : ViewModel(), KoinComponent {

    private val getTagById: GetNfcTaggableByIdUseCase by inject()
    private val saveTag: SaveNfcTaggableUseCase by inject()
    private val deleteTag: DeleteNfcTaggableUseCase by inject()
    private val nfcTaggableRepository: NfcTaggableRepository by inject()
    private val assignmentRepository: AssignmentRepository by inject()



    private val _uiState = MutableStateFlow(viewModelScope, AssetDetailUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AssetDetailUiState> = _uiState.asStateFlow()

    fun hydrate(item: NfcTaggable) {
        _uiState.value = _uiState.value.copy(
            asset = item,
            isLoading = false,
            errorMessage = null,
            operationSucceeded = false
        )
    }

    fun start(item: NfcTaggable, refresh: Boolean = true) {
        hydrate(item)
        if (refresh) loadByIdInternal(item.id)
    }

    fun load(assetId: Uuid) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, errorMessage = null)

            try {
                val asset = nfcTaggableRepository.getById(assetId)
                val current = assignmentRepository.currentAssigneeOf(assetId)
                val lastAssignees = assignmentRepository.lastAssigneesOf(assetId, limit = 3)

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    asset = asset,
                    name = asset?.name.orEmpty(),
                    status = asset?.tagStatus,
                    currentAssigneeId = current?.id?.toString(),
                    currentAssigneeName = current?.name,
                    lastAssignees = lastAssignees
                )
            } catch (t: Throwable) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    errorMessage = t.message ?: "Fehler beim Laden."
                )
            }
        }
    }

    fun reloadAssignments(assetId: Uuid) {
        viewModelScope.launch {
            try {
                val current = assignmentRepository.currentAssigneeOf(assetId)
                val lastAssignees = assignmentRepository.lastAssigneesOf(assetId, limit = 3)

                _uiState.value = _uiState.value.copy(
                    currentAssigneeName = current?.name,
                    lastAssignees = lastAssignees
                )
            } catch (t: Throwable) {
                _uiState.value = _uiState.value.copy(
                    errorMessage = t.message ?: "Fehler beim Laden."
                )
            }
        }
    }

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
                            currentState.copy(asset = loadedItem, isLoading = false)
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
        val current = _uiState.value.asset ?: return
        _uiState.value = _uiState.value.copy(
            asset = current.withName(newName),
            isDirty = true
        )
    }

    fun setStatusInState(newStatus: TagStatus) {
        val current = _uiState.value.asset ?: return
        _uiState.value = _uiState.value.copy(
            asset = current.withStatus(newStatus),
            isDirty = true
        )
    }

    fun allStatuses(): List<TagStatus> =
        try { TagStatus.entries } catch (_: Throwable) { TagStatus.values().toList() }

    fun saveCurrentItem() {
        val itemToSave = _uiState.value.asset ?: return
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isSaving = true,
                errorMessage = null,
                operationSucceeded = false
            )
            runCatching { saveTag(itemToSave) }
                .onSuccess { savedItem ->
                    _uiState.value = _uiState.value.copy(
                        asset = savedItem,
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
                            asset = null,
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