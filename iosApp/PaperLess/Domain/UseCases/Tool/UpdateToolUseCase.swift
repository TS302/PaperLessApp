//
//  UpdateToolUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 16.06.25.
//

import Foundation

struct UpdateToolUseCase {
    private var repository: ToolRepositoryProtocol
    init(repository: ToolRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(tool: Tool) {
        repository.updateTool(tool: tool)
    }
}
