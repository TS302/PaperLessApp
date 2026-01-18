package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.uiStates.AssetUsersUiState
import com.tom.paperless.domain.useCases.AddAssetUserUseCase
import com.tom.paperless.domain.useCases.DeleteAssetUserUseCase
import com.tom.paperless.domain.useCases.FilterAssetUsersUseCase
import com.tom.paperless.domain.useCases.GetAllAssetUsersUseCase
import com.tom.paperless.domain.useCases.ObserveAllAssetUsersUseCase
import com.tom.paperless.domain.useCases.UpdateAssetUserUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssetUsersViewModel() : ViewModel(), KoinComponent {

    private val getAllAssetUsers: GetAllAssetUsersUseCase by inject()
    private val addAssetUser: AddAssetUserUseCase by inject()
    private val updateAssetUser: UpdateAssetUserUseCase by inject()
    private val deleteAssetUser: DeleteAssetUserUseCase by inject()
    private val filterAssetUsers: FilterAssetUsersUseCase by inject()
    private val observeAllAssetUsers: ObserveAllAssetUsersUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, AssetUsersUiState.empty())
    @NativeCoroutinesState
    val uiState: StateFlow<AssetUsersUiState> = _uiState.asStateFlow()

    private var lastAllAssetUsers: List<AssetUser> = emptyList()

    init {
        startObservingAssetUsers()
    }

    private fun startObservingAssetUsers() {
        _uiState.value = _uiState.value.copy(isLoading = true)

        observeAllAssetUsers.observe { users ->
            lastAllAssetUsers = users
            recomputeVisibleAssetUsers()
            _uiState.value = _uiState.value.copy(
                isLoading = false,
                errorMessage = null
            )
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