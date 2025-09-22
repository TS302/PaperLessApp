package com.tom.paperless.ui.viewModels


import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.data.repositories.NfcTaggableRepositoryImpl.getById
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.TargetType
import com.tom.paperless.domain.models.uiStates.NfcTaggablesUiState
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import com.tom.paperless.domain.useCases.GetAllNfcTaggablesUseCase
import com.tom.paperless.domain.useCases.GetNfcTaggableByIdUseCase
import com.tom.paperless.domain.useCases.UpdateNfcTaggableUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlin.native.HiddenFromObjC
import kotlin.uuid.Uuid

class CompanyViewModel(
    private val getAllTags: GetAllNfcTaggablesUseCase,
    private val getTagById: GetNfcTaggableByIdUseCase,
    private val addTag: AddNfcTaggableUseCase,
    private val updateTag: UpdateNfcTaggableUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(NfcTaggablesUiState())

    @NativeCoroutinesState
    val uiState: StateFlow<NfcTaggablesUiState> = _uiState

init {
    viewModelScope.launch {
        val items = getAllTags()
        _uiState.value = _uiState.value.copy(items = items)
        println("CompanyVM loaded ${items.size} items")
    }
}


    fun loadAllNfcTaggables() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, errorMessage = null)
            runCatching { getAllTags() }
                .onSuccess { items -> _uiState.value = _uiState.value.copy(items = items, isLoading = false) }
                .onFailure { e -> _uiState.value = _uiState.value.copy(isLoading = false, errorMessage = e.message) }
        }
    }

    fun addNfcTaggable(item: NfcTaggable) {
        viewModelScope.launch {
            runCatching { addTag(item) }
                .onSuccess { loadAllNfcTaggables() }
                .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
        }
    }

    fun updateNfcTaggable(item: NfcTaggable) {
        viewModelScope.launch {
            runCatching { updateTag(item) }
                .onSuccess { loadAllNfcTaggables() }
                .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
        }
    }

    @HiddenFromObjC
    suspend fun getNfcTaggableById(type: TargetType, id: Uuid): NfcTaggable? =
        getById(type, id)
}