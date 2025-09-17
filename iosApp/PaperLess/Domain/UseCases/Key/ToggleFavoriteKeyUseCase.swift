//
//  ToggleFavoriteKeyUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 21.06.25.
//

import Foundation

struct ToggleFavoriteKeyUseCase {
    private let repository: KeyRepositoryProtocol
    init(repository: KeyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(key: Key) {
        repository.toggleFavoriteKey(key: key)
    }
}
