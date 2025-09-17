//
//  ToggleFavoruteToolUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 21.06.25.
//

import Foundation

struct ToggleFavoruteToolUseCase {
    private let repository: ToolRepositoryProtocol
    init(repository: ToolRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(tool: Tool) {
        repository.toggleFavouriteTool(tool: tool)
    }
}
