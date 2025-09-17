//
//  VehicleViewModel.swift
//  PaperLess
//
//  Created by Tom Salih on 07.06.25.
//

import Foundation
import Combine
import SwiftUI

class VehicleListViewModel: ObservableObject {
    
    @Published var selectedSegment = 0
    @Published var showAddVehicle = false
    @Published var searchText: String = ""
    @Published var showEditVehicle = false
    @Published var vehicles: [Vehicle] = []
    @Published var vehicle: Vehicle
    
    private let getVehicles: LoadVehiclesUseCase
    private let addNewVehicle: AddVehicleUseCase
    private let makeEmptyVehicle: MakeEmptyVehicleUseCase
    private let deleteVehicle: DeleteVehicleUseCase
    private let updateVehicle: UpdateVehicleUseCase
    
    init() {
        let repo = VehicleRepository.shared
        self.getVehicles = LoadVehiclesUseCase(repo: repo)
        self.addNewVehicle = AddVehicleUseCase(repo: repo)
        self.makeEmptyVehicle = MakeEmptyVehicleUseCase(repo: repo)
        self.deleteVehicle = DeleteVehicleUseCase(repo: repo)
        self.updateVehicle = UpdateVehicleUseCase(repository: repo)
        
        self.vehicle = makeEmptyVehicle.execute()
        self.updateVehicle.execute(vehicle: vehicle)
        loadVehicles()
    }
    
    func loadVehicles() {
        vehicles = getVehicles.execute()
    }
    
    func addVehicle(vehicle: Vehicle) {
        addNewVehicle.execute(newVehicle: vehicle)
        loadVehicles()
    }
    
    func updateVehicle(vehicle: Vehicle) {
        updateVehicle.execute(vehicle: vehicle)
        loadVehicles()
    }
    
    func deleteVehicle(id: UUID) {
        deleteVehicle.execute(id: id)
        loadVehicles()
    }
    
    func emptyNewVehicle() {
        vehicle = makeEmptyVehicle.execute()
    }
}
