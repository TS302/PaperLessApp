//
//  ToolRepository.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import SwiftUI

class ToolRepository: ToolRepositoryProtocol {
    
    static let shared = ToolRepository()
    private init() { }
    
    private var tools: [Tool] = [
        Tool(nfcTag: NFCTag(id: UUID(), tagID: "003", name: "Henry 2000", status: DeviceStatus.available, icon: ObjectIcon.tool.rawValue), brand: "Henry", toolType: ToolType.staubsauger, isFavorite: false),
        Tool(nfcTag: NFCTag(id: UUID(), tagID: "004", name: "MultiTool 2000", status: DeviceStatus.defect, icon: ObjectIcon.tool.rawValue), brand: "MultiTool", toolType: ToolType.mobilerKran, isFavorite: true)
    ]
    
    func getAllTools() -> [Tool] {
        return tools
    }
    
    func getAllFavouriteTools() -> [Tool] {
        return tools.filter { $0.isFavorite }
    }
    
    func addTool(tool: Tool) {
        tools.append(tool)
    }
    
    func updateTool(tool: Tool) {
        if let index = tools.firstIndex(where: { $0.id == tool.id }) {
            tools[index] = tool
        }
    }
    
    func makeEmptyTool() -> Tool {
        return Tool(
            nfcTag: NFCTag(
                id: UUID(),
                tagID: "", name: "",
                status: DeviceStatus.available,
                icon: ObjectIcon.tool.rawValue
            ),
            brand: "",
            toolType: ToolType.sonstiges,
            isFavorite: true
        )
    }
    
    func deleteTool(id: UUID) {
        tools.removeAll { $0.id == id }
    }
    
    func toggleFavouriteTool(tool: Tool) {
        tool.isFavorite.toggle()
    }
}



