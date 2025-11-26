package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.Employee
import kotlin.uuid.Uuid

data class AssignAssetUiState(
    val isLoading: Boolean = false,
    val employees: List<Employee> = emptyList(),
    val selectedEmployeeId: Uuid? = null,
    val errorMessage: String? = null,
    val didAssignSuccessfully: Boolean = false,
    val currentAssigneeId: Uuid? = null,
    val currentAssigneeName: String? = null,
    val lastAssignees: List<Employee> = emptyList(),
    val assetDisplayName: String? = null,
    val dialogType: DialogType? = null,
    val lastAssignments: List<Assignment> = emptyList(),
    val noteText: String = ""
) {
    enum class DialogType {
        CONFIRM_ASSIGN,
        CONFIRM_REASSIGN
    }

//    enum class PendingAction {
//        ASSIGN,
//        REASSIGN
//    }
}