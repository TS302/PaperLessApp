package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.uiStates.AssetUsersUiState
import com.tom.paperless.domain.useCases.employeesUseCases.AddAssetUserUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.DeleteAssetUserUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.FilterAssetUsersUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.GetAllAssetUsersUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.UpdateAssetUserUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssetUsersViewModel() : ViewModel(), KoinComponent {

    private val getAllAssetUsere: GetAllAssetUsersUseCase by inject()
    private val addAssetUser: AddAssetUserUseCase by inject()
    private val updateAssetUser: UpdateAssetUserUseCase by inject()
    private val deleteAssetUser: DeleteAssetUserUseCase by inject()
    private val filterAssetUsers: FilterAssetUsersUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, AssetUsersUiState.empty())
    @NativeCoroutinesState
    val uiState: StateFlow<AssetUsersUiState> = _uiState.asStateFlow()

    private var lastAllAssetUsers: List<AssetUser> = emptyList()

    init {
        viewModelScope.launch {
            getAllAssetUsere().collectLatest { allAssetUsers ->
                lastAllAssetUsers = allAssetUsers
                val currentSearchText = _uiState.value.searchQueryText
                val filteredEmployees =
                    filterAssetUsers(allAssetUsers, currentSearchText)

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    items = filteredEmployees,
                    errorMessage = null
                )
            }
        }
    }

    fun setSearchQuery(newSearchText: String) {
        _uiState.value = _uiState.value.copy(searchQueryText = newSearchText)
        recomputeVisibleAssetUsers()
    }

    private fun recomputeVisibleAssetUsers() {
        val stateBefore = _uiState.value
        val filteredAssetUsers =
            filterAssetUsers(lastAllAssetUsers, stateBefore.searchQueryText)

        _uiState.value = stateBefore.copy(items = filteredAssetUsers)
    }

    fun add(assetUser: AssetUser) = viewModelScope.launch {
        runCatching { addAssetUser(assetUser) }
            .onFailure { error ->
                _uiState.value = _uiState.value.copy(errorMessage = error.message)
            }
    }

    fun update(assetUser: AssetUser) = viewModelScope.launch {
        runCatching { updateAssetUser(assetUser) }
            .onFailure { error ->
                _uiState.value = _uiState.value.copy(errorMessage = error.message)
            }
    }

    fun delete(employeeId: Uuid) = viewModelScope.launch {
        runCatching { deleteAssetUser(employeeId) }
            .onFailure { error ->
                _uiState.value = _uiState.value.copy(errorMessage = error.message)
            }
    }

    fun setSearchQueryForIos(searchText: String) = setSearchQuery(searchText)

}