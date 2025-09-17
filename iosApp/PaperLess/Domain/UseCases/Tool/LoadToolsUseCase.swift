//
//  LoadToolsUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import Foundation

struct LoadToolsUseCase {
    private let repository: ToolRepositoryProtocol
    
    init(repository: ToolRepositoryProtocol) {
          self.repository = repository
      }
    
    func execute() -> [Tool] {
        repository.getAllTools()
    }
}


