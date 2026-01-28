package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.uiStates.AssignAssetUiState
import com.tom.paperless.domain.useCases.AssignAssetToEmployeeUseCase
import com.tom.paperless.domain.useCases.GetCurrentAssigneeUseCase
import com.tom.paperless.domain.useCases.GetLastAssigneesUseCase
import com.tom.paperless.domain.useCases.ObserveAllAssetUsersUseCase
import com.tom.paperless.domain.useCases.ReassignAssetUseCase
import com.tom.paperless.domain.useCases.ReturnAssetUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid


class AssignAssetViewModel : ViewModel(), KoinComponent {

    private val assignAssetToEmployeeUseCase: AssignAssetToEmployeeUseCase by inject()
//    private val returnAssetUseCase: ReturnAssetUseCase by inject()
    private val getCurrentAssignee: GetCurrentAssigneeUseCase by inject()
    private val getLastAssignees: GetLastAssigneesUseCase by inject()
//    private val assetUserRepository: AssetUserRepository by inject()
    private val observeAllAssetUsers: ObserveAllAssetUsersUseCase by inject()
    private val reassignAssetUseCase: ReassignAssetUseCase by inject()


    private val _uiState = MutableStateFlow(viewModelScope, AssignAssetUiState())
    @NativeCoroutinesState
    val uiState: StateFlow<AssignAssetUiState> = _uiState.asStateFlow()

    init {
        startObservingAssetUsers()
    }

    private fun startObservingAssetUsers() {
        _uiState.value = _uiState.value.copy(isLoading = true)

        observeAllAssetUsers.observe { users ->
            _uiState.value = _uiState.value.copy(
                assetUsers = users,
                isLoading = false,
                errorMessage = null
            )
        }
    }

    override fun onCleared() {
        super.onCleared()
        observeAllAssetUsers.stop()
    }

    fun attach(assetIdString: String) {
        val assetId = runCatching { Uuid.parse(assetIdString) }.getOrNull() ?: return
        if (_uiState.value.assetId == assetId) return

        _uiState.value = _uiState.value.copy(assetId = assetId)
        load(assetId)
    }

    private fun load(assetId: Uuid) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isLoading = true,
                errorMessage = null
            )

            try {
                val currentAssignee = getCurrentAssignee(assetId)
                val lastAssignees = getLastAssignees(assetId = assetId, limit = 3)

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
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

    // ✅ Normal zuweisen: Note gehört ins neue Assignment -> fromNote
    fun assignToEmployee(employeeId: String, fromNote: String?) = viewModelScope.launch {
        val assetId = _uiState.value.assetId ?: return@launch
        val employeeUuid = runCatching { Uuid.parse(employeeId) }.getOrNull() ?: return@launch

        runCatching {
            // absichtlich ohne named params -> weniger Fehler durch Parameternamen
            assignAssetToEmployeeUseCase(employeeUuid, assetId, fromNote)
        }.onSuccess {
            load(assetId)
            _uiState.value = _uiState.value.copy(
                didAssignSuccessfully = true,
                noteText = ""
            )
        }.onFailure { error ->
            _uiState.value = _uiState.value.copy(errorMessage = error.message)
        }
    }

    // ✅ Übergabe (Reassign):
    // - altes Assignment schließen -> untilNote
    // - neues Assignment anlegen -> fromNote
    fun reassignToEmployee(employeeId: String, untilNote: String?, fromNote: String?) = viewModelScope.launch {
        val assetId = _uiState.value.assetId ?: return@launch
        val employeeUuid = runCatching { Uuid.parse(employeeId) }.getOrNull() ?: return@launch

        // wir nutzen hier EINEN Text für beide Notes
        val note = fromNote ?: untilNote

        runCatching {
            reassignAssetUseCase(
                assetId = assetId,
                newEmployeeId = employeeUuid,
                note = note
            )
        }.onSuccess {
            load(assetId)
            _uiState.value = _uiState.value.copy(noteText = "")
        }.onFailure { error ->
            _uiState.value = _uiState.value.copy(errorMessage = error.message)
        }
    }

    fun setNoteText(value: String) {
        _uiState.update { it.copy(noteText = value) }
    }

    fun onEmployeeTapped(assetUser: AssetUser) {
        _uiState.update { it.copy(selectedEmployeeName = assetUser.name) }
    }

    fun resetSuccessFlag() {
        _uiState.update { it.copy(didAssignSuccessfully = false) }
    }
}

//class AssignAssetViewModel : ViewModel(), KoinComponent {
//
//    private val assignAssetToEmployeeUseCase: AssignAssetToEmployeeUseCase by inject()
//    private val getCurrentAssignee: GetCurrentAssigneeUseCase by inject()
//    private val getLastAssignees: GetLastAssigneesUseCase by inject()
//    private val observeAllAssetUsers: ObserveAllAssetUsersUseCase by inject()
//    private val reassignAssetUseCase: ReassignAssetUseCase by inject()
//
//
//    private val _uiState = MutableStateFlow(viewModelScope, AssignAssetUiState())
//    @NativeCoroutinesState
//    val uiState: StateFlow<AssignAssetUiState> = _uiState.asStateFlow()
//
//    private var lastAllAssetUsers: List<AssetUser> = emptyList()
//
//    init {
//        startObservingAssetUsers()
//    }
//
//    private fun startObservingAssetUsers() {
//        _uiState.value = _uiState.value.copy(isLoading = true)
//
//        observeAllAssetUsers.observe { users ->
//            lastAllAssetUsers = users
//
//            _uiState.value = _uiState.value.copy(
//                assetUsers = users,
//                errorMessage = null
//            )
//        }
//    }
//
//    override fun onCleared() {
//        super.onCleared()
//        observeAllAssetUsers.stop()
//    }
//
//    fun attach(assetIdString: String) {
//        val assetId = runCatching { Uuid.parse(assetIdString) }.getOrNull()
//            ?: return
//
//        if (_uiState.value.assetId == assetId) return
//
//        _uiState.value = _uiState.value.copy(assetId = assetId)
//        load(assetId)
//    }
//
//    private fun load(assetId: Uuid) {
//        viewModelScope.launch {
//            _uiState.value = _uiState.value.copy(
//                isLoading = true,
//                errorMessage = null
//            )
//
//            try {
//                val currentAssignee = getCurrentAssignee(assetId)
//                val lastAssignees = getLastAssignees(assetId = assetId, limit = 3)
//
//                _uiState.value = _uiState.value.copy(
//                    isLoading = false,
//                    currentAssigneeId = currentAssignee?.id,
//                    currentAssigneeName = currentAssignee?.name,
//                    lastAssignees = lastAssignees
//                )
//            } catch (t: Throwable) {
//                _uiState.value = _uiState.value.copy(
//                    isLoading = false,
//                    errorMessage = t.message
//                )
//            }
//        }
//    }
//
//    fun assignToEmployee(employeeId: String, fromNote: String?) = viewModelScope.launch {
//        val assetId = _uiState.value.assetId ?: return@launch
//        val employeeUuid = runCatching { Uuid.parse(employeeId) }.getOrNull() ?: return@launch
//
//        runCatching {
//            assignAssetToEmployeeUseCase(
//                employeeId = employeeUuid,
//                assetId = assetId,
//                fromNote = fromNote
//            )
//        }.onSuccess {
//            load(assetId)
//            _uiState.value = _uiState.value.copy(
//                didAssignSuccessfully = true,
//                noteText = ""
//            )
//        }.onFailure {
//            _uiState.value = _uiState.value.copy(errorMessage = it.message)
//        }
//    }
//
//    fun reassignToEmployee(
//        employeeId: String,
//        note: String?
//    ) = viewModelScope.launch {
//
//        val assetId = _uiState.value.assetId ?: return@launch
//        val employeeUuid = Uuid.parse(employeeId)
//
//        reassignAssetUseCase(
//            assetId = assetId,
//            newEmployeeId = employeeUuid,
//            note = note
//        )
//
//        load(assetId)
//        _uiState.value = _uiState.value.copy(noteText = "")
//    }
//
//    fun setNoteText(value: String) {
//        _uiState.update { it.copy(noteText = value) }
//    }
//
//    fun onEmployeeTapped(assetUser: AssetUser) {
//        _uiState.update {
//            it.copy(selectedEmployeeName = assetUser.name)
//        }
//    }
//
//    fun resetSuccessFlag() {
//        _uiState.update {
//            it.copy(didAssignSuccessfully = false)
//        }
//    }
//}