//
//  MakeEmptyKeyUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 16.06.25.
//

import Foundation

struct MakeEmptyKeyUseCase {
    private var repository: KeyRepositoryProtocol
    init(repository: KeyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Key {
        return repository.makeEmptyKey()
    }
}
