//
//  LoadFavoriteKeyUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 21.06.25.
//

import Foundation

struct LoadFavoriteKeyUseCase {
    private let repository: KeyRepositoryProtocol
    init(repository: KeyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> [Key] {
        repository.getAllFavoriteKeys()
    }
}
