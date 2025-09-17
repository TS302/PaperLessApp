//
//  EditVehicleViewModel.swift
//  PaperLess
//
//  Created by Tom Salih on 29.06.25.
//

import Foundation
import Combine

class EditVehicleViewModel: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var vehicle: Vehicle?
    
    private let getVehicles: LoadVehiclesUseCase
    private let updateVehicle: UpdateVehicleUseCase
    
    init() {
        let vehicleRepository = VehicleRepository.shared
        self.getVehicles = LoadVehiclesUseCase(repo: vehicleRepository)
        self.updateVehicle = UpdateVehicleUseCase(repository: vehicleRepository)
        
        self.vehicle = vehicle
        
    }
    
    func loadVehicles() {
        vehicles = getVehicles.execute()
    }
    
    func updateVehicle(vehicle: Vehicle) {
        updateVehicle.execute(vehicle: vehicle)
        loadVehicles()
    }
}
