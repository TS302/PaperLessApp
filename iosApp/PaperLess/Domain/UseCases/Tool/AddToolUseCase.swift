//
//  AddToolUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 16.06.25.
//

import Foundation

struct AddToolUseCase {
    private let repository: ToolRepositoryProtocol
    init(repository: ToolRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(newTool: Tool) {
        repository.addTool(tool: newTool)
    }
}
