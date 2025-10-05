package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.NfcTaggable

data class ItemDetailUiState(
    val item: NfcTaggable? = null,
    val isLoading: Boolean = false,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val errorMessage: String? = null,
    val operationSucceeded: Boolean = false,

    val isDirty: Boolean = false,
    val isEditing: Boolean = false
) {
    companion object {
        fun empty() = ItemDetailUiState()
    }
}
