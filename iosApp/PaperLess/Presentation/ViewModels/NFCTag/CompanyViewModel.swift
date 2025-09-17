//
//  NFCViewModel.swift
//  PaperLess
//
//  Created by Tom Salih on 25.05.25.
//

import Foundation
import Combine

final class CompanyViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var selectedSegment = 0
    @Published var selectedFavoriteNFCTagSegment = 0
    @Published var showAddVehicle = false
    @Published var showAddTool = false
    @Published var showAddKey = false
    
    @Published var showEditVehicle = false
    @Published var showEditTool = false
    @Published var showEditKey = false
    @Published var vehicles: [Vehicle] = []
    @Published var tools: [Tool] = []
    @Published var keys: [Key] = []
    
    private let getVehicles: LoadVehiclesUseCase
    private let updateVehicle: UpdateVehicleUseCase
    private let deleteVehicle: DeleteVehicleUseCase
    
    private let getTools: LoadToolsUseCase
    private let updateTool: UpdateToolUseCase
    private let deleteTool: DeleteToolUseCase
    
    private let getKeys: LoadKeysUseCase
    private let updateKey: UpdateKeyUseCase
    private let deleteKey: DeleteKeyUseCase
    
    init() {
        let vehicleRepository = VehicleRepository.shared
        let toolRepository = ToolRepository.shared
        let keyRepository = KeyRepository.shared
        
        self.getVehicles = LoadVehiclesUseCase(repo: vehicleRepository)
        self.updateVehicle = UpdateVehicleUseCase(repository: vehicleRepository)
        self.deleteVehicle = DeleteVehicleUseCase(repo: vehicleRepository)
        
        self.getTools = LoadToolsUseCase(repository: toolRepository)
        self.updateTool = UpdateToolUseCase(repository: toolRepository)
        self.deleteTool = DeleteToolUseCase(repository: toolRepository)
        
        self.getKeys = LoadKeysUseCase(repository: keyRepository)
        self.updateKey = UpdateKeyUseCase(repository: keyRepository)
        self.deleteKey = DeleteKeyUseCase(repository: keyRepository)
        
        loadVehicles()
        loadTools()
        loadKeys()
    }
    
    func loadVehicles() {
        vehicles = getVehicles.execute()
    }
    
    func updateVehicle(vehicle: Vehicle) {
        updateVehicle.execute(vehicle: vehicle)
        loadVehicles()
    }
    
    func deleteVehicle(id: UUID) {
        deleteVehicle.execute(id: id)
        loadVehicles()
    }
    
    
    func loadTools() {
        tools = getTools.execute()
    }
    
    func updateTool(tool: Tool) {
        updateTool.execute(tool: tool)
        loadTools()
    }
    
    func deleteTool(id: UUID) {
        deleteTool.execute(id: id)
        loadTools()
    }
    
    
    func loadKeys() {
        keys = getKeys.execute()
    }
    
    func updateKey(key: Key) {
        updateKey.execute(key: key)
        loadKeys()
    }
    
    func deleteKey(id: UUID) {
        deleteKey.execute(id: id)
        loadKeys()
    }

}


