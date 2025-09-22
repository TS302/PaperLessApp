package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.NfcTaggable

data class NfcTaggablesUiState(
    val items: List<NfcTaggable> = emptyList(),
    val isLoading: Boolean = false,
    val errorMessage: String? = null,
    val selected: NfcTaggable? = null
)
