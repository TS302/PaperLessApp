package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagStatus

data class EditAssetUiState(
    val asset: NfcTaggable? = null,

    // Formular-Felder
    val name: String = "",
    val status: TagStatus? = null,
    val brand: String? = "",
    val plate: String? = null,
    val serialNumber: String? = "",

    // UI-Zustände
    val isLoading: Boolean = false,
    val isSaving: Boolean = false,
    val errorMessage: String? = null,
    val operationSucceeded: Boolean = false,
    val isDirty: Boolean = false,
    val isEditing: Boolean = false
) {
    companion object {
        fun empty() = EditAssetUiState()
    }
}
