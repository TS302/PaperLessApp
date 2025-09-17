//
//  DeleteToolUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import Foundation

struct DeleteToolUseCase {
    private let repository: ToolRepositoryProtocol
    
    init(repository: ToolRepositoryProtocol) {
        self.repository = repository
    }
    
     func execute(id: UUID) {
        repository.deleteTool(id: id)
    }
}
