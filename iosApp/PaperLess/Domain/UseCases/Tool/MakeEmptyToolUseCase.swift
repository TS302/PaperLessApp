//
//  MakeEmptyToolUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 16.06.25.
//

import Foundation

struct MakeEmptyToolUseCase {
    private let repository: ToolRepositoryProtocol
    
    init(repository: ToolRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Tool {
        return repository.makeEmptyTool()
    }
}
