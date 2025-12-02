package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TargetType
import com.tom.paperless.domain.models.uiStates.AssetsUiState
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import com.tom.paperless.domain.useCases.DeleteNfcTaggableUseCase
import com.tom.paperless.domain.useCases.FilterNfcTaggablesUseCase
import com.tom.paperless.domain.useCases.GetAllNfcTaggablesFlowUseCase
import com.tom.paperless.domain.useCases.SaveNfcTaggableUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssetsViewModel() : ViewModel(), KoinComponent {

    private val getAllNfcTaggables: GetAllNfcTaggablesFlowUseCase by inject()
    private val addNfcTaggable: AddNfcTaggableUseCase by inject()
    private val saveNfcTaggable: SaveNfcTaggableUseCase by inject()
    private val deleteNfcTaggable: DeleteNfcTaggableUseCase by inject()
    private val filterNfcTaggables: FilterNfcTaggablesUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, AssetsUiState.empty())

    @NativeCoroutinesState
    val uiState: StateFlow<AssetsUiState> = _uiState.asStateFlow()

    private var lastAllItems: List<NfcTaggable> = emptyList()

init {
    viewModelScope.launch {
        getAllNfcTaggables().collectLatest { allItems ->
            lastAllItems = allItems

            val state = _uiState.value
            val visible = filterNfcTaggables(
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
        val visible = filterNfcTaggables(
            allItems = lastAllItems,
            typeFilter = state.activeTypeFilter,
            searchQueryText = state.searchQueryText
        )
        _uiState.value = state.copy(items = visible)
    }

    fun addItem(itemToAdd: NfcTaggable) = viewModelScope.launch {
        runCatching { addNfcTaggable(itemToAdd) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    fun updateItem(itemToSave: NfcTaggable) = viewModelScope.launch {
        runCatching { saveNfcTaggable(itemToSave) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    fun deleteItem(id: Uuid) = viewModelScope.launch {
        runCatching { deleteNfcTaggable(id) }
            .onFailure { e -> _uiState.value = _uiState.value.copy(errorMessage = e.message) }
    }

    // ---------- iOS Helper ----------
    fun setTypeFilterForIos(typeFilter: TargetType?) = setTypeFilter(typeFilter)
    fun setSearchQueryForIos(queryText: String) = setSearchQuery(queryText)

}