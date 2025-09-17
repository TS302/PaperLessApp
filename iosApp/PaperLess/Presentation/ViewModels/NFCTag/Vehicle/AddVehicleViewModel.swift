//
//  AddVehicleViewModel.swift
//  PaperLess
//
//  Created by Tom Salih on 28.06.25.
//

import Foundation
import Combine

class AddVehicleViewModel: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var vehicle: Vehicle
    
    private let getVehicles: LoadVehiclesUseCase
    private let addNewVehicle: AddVehicleUseCase
    private let makeEmptyVehicle: MakeEmptyVehicleUseCase
    
    init() {
        let vehicleRepository = VehicleRepository.shared
        self.getVehicles = LoadVehiclesUseCase(repo: vehicleRepository)
        self.addNewVehicle = AddVehicleUseCase(repo: vehicleRepository)
        self.makeEmptyVehicle = MakeEmptyVehicleUseCase(repo: vehicleRepository)
        
        self.vehicle = makeEmptyVehicle.execute()
        loadVehicles()
    }
    
    func loadVehicles() {
        vehicles = getVehicles.execute()
    }
    
    func addVehicle(vehicle: Vehicle) {
        addNewVehicle.execute(newVehicle: vehicle)
        loadVehicles()
    }
    
    func emptyNewVehicle() {
        vehicle = makeEmptyVehicle.execute()
    }
    
}
