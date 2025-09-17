//
//  LoadFavoriteToolUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 21.06.25.
//

import Foundation

struct LoadFavoriteToolUseCase {
    private let repository: ToolRepositoryProtocol
    init(repository: ToolRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> [Tool] {
        repository.getAllFavouriteTools()
    }
    
    
}
