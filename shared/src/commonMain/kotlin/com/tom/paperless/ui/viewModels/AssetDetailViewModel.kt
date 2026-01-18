package com.tom.paperless.ui.viewModels


import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.mappers.withName
import com.tom.paperless.domain.mappers.withStatus
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.uiStates.AssetDetailUiState
import com.tom.paperless.domain.useCases.DeleteNfcTaggableUseCase
import com.tom.paperless.domain.useCases.GetAssetUserByIdUseCase
import com.tom.paperless.domain.useCases.GetAssignmentsByAssetUseCase
import com.tom.paperless.domain.useCases.GetCurrentAssigneeUseCase
import com.tom.paperless.domain.useCases.GetNfcTaggableByIdUseCase
import com.tom.paperless.domain.useCases.ObserveAssignmentsByAssetUseCase
import com.tom.paperless.domain.useCases.SaveNfcTaggableUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssetDetailViewModel : ViewModel(), KoinComponent {

    private val getTagById: GetNfcTaggableByIdUseCase by inject()
    private val saveTag: SaveNfcTaggableUseCase by inject()
    private val deleteTag: DeleteNfcTaggableUseCase by inject()
    private val getAssignmentsByAsset: GetAssignmentsByAssetUseCase by inject()
    private val getCurrentAssignee: GetCurrentAssigneeUseCase by inject()
    private val getUserById: GetAssetUserByIdUseCase by inject()
    private val observeAssignmentsByAsset: ObserveAssignmentsByAssetUseCase by inject()


    private val _uiState =
        MutableStateFlow(viewModelScope, AssetDetailUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AssetDetailUiState> = _uiState.asStateFlow()

    fun start(assetId: Uuid) {
        loadAsset(assetId)
        observeAssignments(assetId)
    }

    override fun onCleared() {
        super.onCleared()
        observeAssignmentsByAsset.stop()
    }

    private fun loadAsset(assetId: Uuid) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true)

            runCatching { getTagById(assetId) }
                .onSuccess { asset ->
                    _uiState.value = _uiState.value.copy(
                        asset = asset,
                        name = asset?.name.orEmpty(),
                        status = asset?.tagStatus,
                        isLoading = false
                    )
                }
                .onFailure { error ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        errorMessage = error.message ?: "Fehler beim Laden des Assets"
                    )
                }
        }
    }

    private fun observeAssignments(assetId: Uuid) {
        observeAssignmentsByAsset.observe(assetId) { assignments ->

            val currentAssignment = assignments.firstOrNull { it.until == null }

            viewModelScope.launch {
                val currentAssignee = currentAssignment?.assetUserId
                    ?.let { getUserById(it) }

                val historyAssignees = assignments.mapNotNull { assignment ->
                    assignment.assetUserId?.let { getUserById(id = it) }
                }

                _uiState.value = _uiState.value.copy(
                    currentAssigneeName = currentAssignee?.name,
                    currentAssignmentNote = currentAssignment?.note,
                    lastAssignments = assignments,
                    lastAssignees = historyAssignees
                )
            }


//            viewModelScope.launch {
//                val assignee = currentAssignment?.assetUserId
//                    ?.let { getUserById(it) }
//
//                _uiState.value = _uiState.value.copy(
//                    currentAssigneeName = assignee?.name,
//                    currentAssignmentNote = currentAssignment?.note,
//                    lastAssignments = assignments
//                )
//            }
        }
    }

//    private fun loadAssignments(assetId: Uuid) {
//        viewModelScope.launch {
//            try {
//                val currentAssignee = getCurrentAssignee(assetId)
//
//                val history = getAssignmentsByAsset(assetId)
//
//                _uiState.value = _uiState.value.copy(
//                    currentAssigneeName = currentAssignee?.name,
//                    currentAssignmentNote = currentAssignee?.note,
//                    lastAssignments = history
//                )
//            } catch (t: Throwable) {
//                _uiState.value = _uiState.value.copy(
//                    errorMessage = t.message
//                )
//            }
//        }
//    }
//    fun reloadAssignments(assetId: Uuid) {
//        loadAssignments(assetId)
//    }



    fun allStatuses(): List<TagStatus> =
        try { TagStatus.entries } catch (_: Throwable) { TagStatus.values().toList() }

    fun save() {
        val asset = _uiState.value.asset ?: return

        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isSaving = true)

            runCatching { saveTag(asset) }
                .onSuccess { saved ->
                    _uiState.value = _uiState.value.copy(
                        asset = saved,
                        isSaving = false,
                        isDirty = false,
                        operationSucceeded = true
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

    fun delete() {
        val id = _uiState.value.asset?.id ?: return

        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isDeleting = true)

            runCatching { deleteTag(id) }
                .onSuccess {
                    _uiState.value = _uiState.value.copy(
                        asset = null,
                        isDeleting = false,
                        operationSucceeded = true
                    )
                }
                .onFailure { error ->
                    _uiState.value = _uiState.value.copy(
                        isDeleting = false,
                        errorMessage = error.message
                    )
                }
        }
    }

    fun clearMessages() {
        _uiState.value = _uiState.value.copy(
            errorMessage = null,
            operationSucceeded = false
        )
    }

    fun setEditing(active: Boolean) {
        _uiState.value = _uiState.value.copy(isEditing = active)
    }

    fun setName(newName: String) {
        val asset = _uiState.value.asset ?: return
        _uiState.value = _uiState.value.copy(
            asset = asset.withName(newName),
            isDirty = true
        )
    }

    fun setStatus(newStatus: TagStatus) {
        val asset = _uiState.value.asset ?: return
        _uiState.value = _uiState.value.copy(
            asset = asset.withStatus(newStatus),
            isDirty = true
        )
    }
}
