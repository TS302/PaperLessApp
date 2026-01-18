package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.uiStates.AssignAssetUiState
import com.tom.paperless.domain.useCases.AssignAssetToEmployeeUseCase
import com.tom.paperless.domain.useCases.GetAssetUserByIdUseCase
import com.tom.paperless.domain.useCases.GetCurrentAssigneeUseCase
import com.tom.paperless.domain.useCases.GetLastAssigneesUseCase
import com.tom.paperless.domain.useCases.ReturnAssetUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssignAssetViewModel : ViewModel(), KoinComponent {

    private val assignAssetToEmployeeUseCase: AssignAssetToEmployeeUseCase by inject()
    private val returnAssetUseCase: ReturnAssetUseCase by inject()
    private val getCurrentAssignee: GetCurrentAssigneeUseCase by inject()
    private val getLastAssignees: GetLastAssigneesUseCase by inject()
    private val assetUserRepository: AssetUserRepository by inject()

    private val _uiState = MutableStateFlow(viewModelScope, AssignAssetUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AssignAssetUiState> = _uiState.asStateFlow()

    private var itemId: Uuid? = null

    fun attach(assetIdString: String) {
        val parsed = runCatching { Uuid.parse(assetIdString) }.getOrNull()
            ?: run {
                _uiState.value = _uiState.value.copy(errorMessage = "Ungültige Asset-ID")
                return
            }

        if (itemId == parsed) return
        itemId = parsed

        load(parsed)
    }

    private fun load(assetId: Uuid) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isLoading = true,
                errorMessage = null
            )

            try {
                val assetUsers = assetUserRepository.getAll()
                println("DEBUG getAll() count = ${assetUsers.size}")
                println("DEBUG first user = ${assetUsers.firstOrNull()}")
                val currentAssignee = getCurrentAssignee(assetId)

                val lastAssignees = getLastAssignees(
                    assetId = assetId,
                    limit = 3
                )

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    assetUsers = assetUsers,
                    currentAssigneeId = currentAssignee?.id,
                    currentAssigneeName = currentAssignee?.name,
                    lastAssignees = lastAssignees
                )
            } catch (t: Throwable) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    errorMessage = t.message
                )
            }
        }
    }

    fun assignToEmployee(employeeId: Uuid, note: String?) {
        val assetId = itemId ?: return

        viewModelScope.launch {
            try {
                assignAssetToEmployeeUseCase(
                    employeeId = employeeId,
                    assetId = assetId,
                    note = note
                )

                load(assetId)

                _uiState.value = _uiState.value.copy(
                    didAssignSuccessfully = true,
                    noteText = ""
                )
            } catch (t: Throwable) {
                _uiState.value = _uiState.value.copy(errorMessage = t.message)
            }
        }
    }

    fun reassignToEmployee(employeeId: Uuid, note: String?) {
        val assetId = itemId ?: return

        viewModelScope.launch {
            try {
                returnAssetUseCase(assetId)
                assignToEmployee(employeeId, note)
            } catch (t: Throwable) {
                _uiState.value = _uiState.value.copy(errorMessage = t.message)
            }
        }
    }

    fun setNoteText(value: String) {
        _uiState.update { it.copy(noteText = value) }
    }

    fun onEmployeeTapped(assetUser: AssetUser) {
        _uiState.update {
            it.copy(selectedEmployeeName = assetUser.name)
        }
    }

    fun resetSuccessFlag() {
        _uiState.update {
            it.copy(didAssignSuccessfully = false)
        }
    }
}