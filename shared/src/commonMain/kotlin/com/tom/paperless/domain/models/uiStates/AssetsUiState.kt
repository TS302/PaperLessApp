package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagType

data class AssetsUiState(
    val assets: List<NfcTaggable> = emptyList(),
    val isLoading: Boolean = false,
    val errorMessage: String? = null,

    val selectedItem: NfcTaggable? = null,
    val activeTypeFilter: TagType? = null,
    val searchQueryText: String = ""
) {
    companion object Companion {
        fun empty() = AssetsUiState()
    }
}
