package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TargetType

data class NfcTaggablesUiState(
    val items: List<NfcTaggable> = emptyList(),
    val isLoading: Boolean = false,
    val errorMessage: String? = null,

    val selectedItem: NfcTaggable? = null,
    val activeTypeFilter: TargetType? = null,
    val searchQueryText: String = ""
)
