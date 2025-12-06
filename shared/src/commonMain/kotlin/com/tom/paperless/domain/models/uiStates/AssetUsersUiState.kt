package com.tom.paperless.domain.models.uiStates

import com.tom.paperless.domain.models.AssetUser

data class AssetUsersUiState(
    val items: List<AssetUser> = emptyList(),
    val searchQueryText: String = "",
    val isLoading: Boolean = false,
    val errorMessage: String? = null
) {
    companion object Companion { fun empty() = AssetUsersUiState() }
}