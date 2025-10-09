package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
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
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlin.uuid.Uuid

class CompanyViewModel(
    private val getAllNfcTaggablesFlowUseCase: GetAllNfcTaggablesFlowUseCase,
    private val addNfcTaggableUseCase: AddNfcTaggableUseCase,
    private val saveNfcTaggableUseCase: SaveNfcTaggableUseCase,
    private val deleteNfcTaggableUseCase: DeleteNfcTaggableUseCase,
    private val filterNfcTaggablesUseCase: FilterNfcTaggablesUseCase
) : ViewModel() {


    private val _uiState = MutableStateFlow(NfcTaggablesUiState.empty())

    @NativeCoroutinesState
    val uiState: StateFlow<NfcTaggablesUiState> = _uiState

init {
    viewModelScope.launch {
        getAllNfcTaggablesFlowUseCase().collectLatest { allItems ->
            val current = _uiState.value
            val visible = filterNfcTaggablesUseCase(
                allItems = allItems,
                typeFilter = current.activeTypeFilter,
                searchQueryText = current.searchQueryText
            )
            _uiState.value = current.copy(items = visible, isLoading = false)
        }
    }
}

    // ---------- Filter & Suche ----------
    fun setTypeFilter(newTypeFilter: TargetType?) {
        val current = _uiState.value
        _uiState.value = current.copy(activeTypeFilter = newTypeFilter)
        recomputeVisibleItems()
    }

    fun setSearchQuery(newSearchQueryText: String) {
        val current = _uiState.value
        _uiState.value = current.copy(searchQueryText = newSearchQueryText)
        recomputeVisibleItems()
    }

    private fun recomputeVisibleItems() = viewModelScope.launch {
        _uiState.value = _uiState.value.copy(isLoading = true)
        val snapshotAll: List<NfcTaggable> = getAllNfcTaggablesFlowUseCase().value
        val state = _uiState.value
        val visible = filterNfcTaggablesUseCase(
            allItems = snapshotAll,
            typeFilter = state.activeTypeFilter,
            searchQueryText = state.searchQueryText
        )
        _uiState.value = state.copy(items = visible, isLoading = false)
    }


    // ---------- CRUD ----------
    fun addItem(itemToAdd: NfcTaggable) {
        viewModelScope.launch {
            try {
                val savedItem: NfcTaggable = addNfcTaggableUseCase(itemToAdd)
                // keine weitere Aktion nötig – Repo-Flow emittiert automatisch neu
                println("addItem OK: ${savedItem.id}")
            } catch (e: Throwable) {
                _uiState.value = _uiState.value.copy(errorMessage = e.message)
            }
        }
    }

    fun updateItem(itemToSave: NfcTaggable) {
        viewModelScope.launch {
            try {
                val savedItem: NfcTaggable = saveNfcTaggableUseCase(itemToSave)
                println("updateItem OK: ${savedItem.id}")
            } catch (e: Throwable) {
                _uiState.value = _uiState.value.copy(errorMessage = e.message)
            }
        }
    }

    fun deleteItem(id: Uuid) {
        viewModelScope.launch {
            try {
                val wasDeleted: Boolean = deleteNfcTaggableUseCase(id)
                if (!wasDeleted) {
                    _uiState.value = _uiState.value.copy(errorMessage = "Löschen fehlgeschlagen.")
                }
                // Bei Erfolg emittiert der Repo-Flow automatisch neu
            } catch (e: Throwable) {
                _uiState.value = _uiState.value.copy(errorMessage = e.message)
            }
        }
    }

    // ---------- iOS Helfer-Methoden ----------
    fun setTypeFilterForIos(typeFilter: TargetType?) = setTypeFilter(typeFilter)
    fun setSearchQueryForIos(queryText: String) = setSearchQuery(queryText)

}