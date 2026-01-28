package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.Assignment
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.NfcTaggable
import kotlin.uuid.Uuid

data class AssignAssetUiState(
    val assetId: Uuid? = null,
    val isLoading: Boolean = false,
    val asset: NfcTaggable? = null,
    val assetUsers: List<AssetUser> = emptyList(),
    val selectedEmployeeId: Uuid? = null,
    val selectedEmployeeName: String? = null,
    val errorMessage: String? = null,
    val didAssignSuccessfully: Boolean = false,
    val currentAssigneeId: Uuid? = null,
    val currentAssigneeName: String? = null,
    val lastAssignees: List<AssetUser> = emptyList(),
    val dialogType: DialogType? = null,
    val lastAssignments: List<Assignment> = emptyList(),
    val noteText: String = ""
) {
    enum class DialogType {
        CONFIRM_ASSIGN,
        CONFIRM_REASSIGN
    }
}