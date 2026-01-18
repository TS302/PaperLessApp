package com.tom.paperless.domain.models.uiStates

data class AssignmentDetailUiState(
    val isCompleting: Boolean,
    val errorMessage: String?,
    val didComplete: Boolean
) {
    companion object {
        fun empty() = AssignmentDetailUiState(
            isCompleting = false,
            errorMessage = null,
            didComplete = false
        )
    }
}