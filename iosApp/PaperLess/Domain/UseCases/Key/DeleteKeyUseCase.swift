//
//  DeleteKeyUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import Foundation

struct DeleteKeyUseCase {
    private let repository: KeyRepositoryProtocol
    init(repository: KeyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: UUID) {
        repository.deleteKey(id: id)
    }
}
