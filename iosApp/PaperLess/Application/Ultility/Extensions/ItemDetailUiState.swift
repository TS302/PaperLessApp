//
//  ItemDetailUiState.swift
//  PaperLess
//
//  Created by Tom Salih on 28.09.25.
//

import Shared

extension ItemDetailUiState {
    static func empty() -> ItemDetailUiState {
        ItemDetailUiState(
            item: nil,
            isLoading: false,
            isSaving: false,
            isDeleting: false,
            errorMessage: nil,
            operationSucceeded: false,
            isDirty: false,
            isEditing: false
        )
    }
}
