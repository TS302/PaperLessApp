package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TargetType
import com.tom.paperless.domain.models.uiStates.NfcTaggablesUiState
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import com.tom.paperless.domain.useCases.DeleteNfcTaggableUseCase
import com.tom.paperless.domain.useCases.FilterNfcTaggablesUseCase
import com.tom.paperless.domain.useCases.GetAllNfcTaggablesFlowUseCase
import com.tom.paperless.domain.useCases.SaveNfcTaggableUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlin.uuid.Uuid

class CompanyViewModel(
    private val getAllNfcTaggablesFlowUseCase: GetAllNfcTaggablesFlowUseCase,
    private val addNfcTaggableUseCase: AddNfcTaggableUseCase,
    private val saveNfcTaggableUseCase: SaveNfcTaggableUseCase,
    private val deleteNfcTaggableUseCase: DeleteNfcTaggableUseCase,
    private val filterNfcTaggablesUseCase: FilterNfcTaggablesUseCase
) : ViewModel() {
    private val _uiState = MutableStateFlow(viewModelScope, NfcTaggablesUiState.empty())

    @NativeCoroutinesState
    val uiState: StateFlow<NfcTaggablesUiState> = _uiState.asStateFlow()

    private var lastAllItems: List<NfcTaggable> = emptyList()

init {
    viewModelScope.launch {
        getAllNfcTaggablesFlowUseCase().collectLatest { allItems ->
            lastAllItems = allItems

            val state = _uiState.value
            val visible = filterNfcTaggablesUseCase(
                allItems = allItems,
                typeFilter = state.activeTypeFilter,
                searchQueryText = state.searchQueryText
            )
            _uiState.value = state.copy(
                isLoading = false,
                items = visible,
                errorMessage = null
            )
        }
    }
}

    fun setTypeFilter(newTypeFilter: TargetType?) {
        _uiState.value = _uiState.value.copy(activeTypeFilter = newTypeFilter)
        recomputeVisibleItems()
    }

    fun setSearchQuery(newSearchQueryText: String) {
        _uiState.value = _uiState.value.copy(searchQueryText = newSearchQueryText)
        recomputeVisibleItems()
    }

    private fun recomputeVisibleItems() {
        val state = _uiState.value
        val visible = filterNfcTaggablesUseCase(
            allItems = lastAllItems,
            typeFilter = state.activeTypeFilter,
            searchQueryText = state.searchQueryText
        )
        _uiState.value = state.copy(items = visible)
    }

    fun addItem(itemToAdd: NfcTaggable) = viewModelScope.launch {
        runCatching { addNfcTaggableUseCase(itemToAdd) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    fun updateItem(itemToSave: NfcTaggable) = viewModelScope.launch {
        runCatching { saveNfcTaggableUseCase(itemToSave) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    fun deleteItem(id: Uuid) = viewModelScope.launch {
        runCatching { deleteNfcTaggableUseCase(id) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    // ---------- iOS Helper ----------
    fun setTypeFilterForIos(typeFilter: TargetType?) = setTypeFilter(typeFilter)
    fun setSearchQueryForIos(queryText: String) = setSearchQuery(queryText)

}