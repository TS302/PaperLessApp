//
//  ToolListViewModel.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import SwiftUI
import Combine

class ToolListViewModel: ObservableObject {
    
    @Published var showAddTool = false
    @Published var searchText: String = ""
    @Published var showEditTool = false
    @Published var selectedSegment = 0
    @Published var tools: [Tool] = []
    @Published var tool: Tool
    @Published var favoriteTools: [Tool] = []
    
    private let getTools: LoadToolsUseCase
    private let getFavoriteTools: LoadFavoriteToolUseCase
    private let deleteTool: DeleteToolUseCase
    private let addTool: AddToolUseCase
    private let makeEmptyTool: MakeEmptyToolUseCase
    private let updateTool: UpdateToolUseCase
    private let toggleFavoriteTool: ToggleFavoruteToolUseCase
    
    init() {
        let repository = ToolRepository.shared
        self.getTools = LoadToolsUseCase(repository: repository)
        self.getFavoriteTools = LoadFavoriteToolUseCase(repository: repository)
        self.addTool = AddToolUseCase(repository: repository)
        self.makeEmptyTool = MakeEmptyToolUseCase(repository: repository)
        self.deleteTool = DeleteToolUseCase(repository: repository)
        self.updateTool = UpdateToolUseCase(repository: repository)
        self.toggleFavoriteTool = ToggleFavoruteToolUseCase(repository: repository)
        
        self.tool = makeEmptyTool.execute()
        self.updateTool.execute(tool: tool)
    }
    
    func loadTools() {
        tools = getTools.execute()
    }
    
    func loadFavoriteTools() {
        favoriteTools = getFavoriteTools.execute()
    }
    
    func addTool(newTool: Tool) {
        addTool.execute(newTool: newTool)
        loadTools()
    }
    
    func updateTool(tool: Tool) {
        updateTool.execute(tool: tool)
        loadTools()
    }
    
    func deleteTool(id: UUID) {
        deleteTool.execute(id: id)
        loadTools()
    }
    
    func toggleToolFavorite(tool: Tool) {
        toggleFavoriteTool.execute(tool: tool)
    }
    
    func emptyNewTool() {
        tool = makeEmptyTool.execute()
    }
    
    
}
