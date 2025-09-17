//
//  LoadKeysUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import Foundation

struct LoadKeysUseCase {
    private let repository: KeyRepositoryProtocol
    
    init(repository: KeyRepositoryProtocol){
        self.repository = repository
    }
    
    func execute() -> [Key] {
        repository.getAllKeys()
    }
}
