package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.ui.AssignedItemUi

data class AssetUserDetailUiState(
    val isLoading: Boolean = false,
    val assetUser: AssetUser? = null,

    val draftName: String = "",
    val draftEmail: String = "",
    val draftPhone: String = "",

    val isEditing: Boolean = false,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val errorMessage: String? = null,
    val operationSucceeded: Boolean = false,
    val isValid: Boolean = false,
    val hasChanges: Boolean = false,

    val assignedItems: List<AssignedItemUi> = emptyList()

) {
    companion object Companion {
        fun empty() = AssetUserDetailUiState()
    }
}