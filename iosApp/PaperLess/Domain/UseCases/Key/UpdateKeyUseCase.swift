//
//  UpdateKeyUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 16.06.25.
//

import Foundation

struct UpdateKeyUseCase {
    private let repository: KeyRepositoryProtocol
    init(repository: KeyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(key: Key) {
        repository.updateKey(key: key)
    }
}
