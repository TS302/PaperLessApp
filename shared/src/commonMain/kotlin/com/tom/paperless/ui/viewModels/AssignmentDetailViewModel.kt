package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.launch
import com.tom.paperless.domain.models.uiStates.AssignmentDetailUiState
import com.tom.paperless.domain.useCases.CompleteAssignmentUseCase
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class AssignmentDetailViewModel : ViewModel(), KoinComponent {

    private val completeAssignment: CompleteAssignmentUseCase by inject()

    private val _uiState = MutableStateFlow(viewModelScope, AssignmentDetailUiState.empty())
    @NativeCoroutinesState
    val uiState: StateFlow<AssignmentDetailUiState> = _uiState.asStateFlow()

    fun complete(
        assignmentId: Uuid,
        assetId: Uuid,
        untilMillis: Long
    ) = viewModelScope.launch {
        _uiState.value = _uiState.value.copy(isCompleting = true, errorMessage = null)

        runCatching {
            completeAssignment(
                assignmentId = assignmentId,
                assetId = assetId,
                untilMillis = untilMillis
            )
        }
            .onSuccess {
                _uiState.value = _uiState.value.copy(isCompleting = false, didComplete = true)
            }
            .onFailure { e ->
                _uiState.value = _uiState.value.copy(isCompleting = false, errorMessage = e.message)
            }
    }

    fun resetDidComplete() {
        _uiState.value = _uiState.value.copy(didComplete = false)
    }
}