//
//  NfcTaggablesUiState.swift
//  PaperLess
//
//  Created by Tom Salih on 23.09.25.
//

import Shared

extension NfcTaggablesUiState {
    static func empty() -> NfcTaggablesUiState {
        NfcTaggablesUiState(
            items: [],
            isLoading: false,
            errorMessage: nil,
            selectedItem: nil,
            activeTypeFilter: nil,
            searchQueryText: ""
        )
    }
}
