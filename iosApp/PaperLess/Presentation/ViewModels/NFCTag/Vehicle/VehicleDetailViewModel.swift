//
//  VehicleDetailViewModel.swift
//  PaperLess
//
//  Created by Tom Salih on 24.06.25.
//

import Foundation
import Combine

class VehicleDetailViewModel: ObservableObject {
    @Published var selectedSegment = 0
    @Published var showEditVehicle = false
    @Published var vehicles: [Vehicle] = []
    @Published var vehicle: Vehicle
    
    private let getVehicles: LoadVehiclesUseCase
    private let updateVehicle: UpdateVehicleUseCase
    private let makeEmptyVehicle: MakeEmptyVehicleUseCase
    
    init() {
        let vehicleRepository = VehicleRepository.shared
        self.getVehicles = LoadVehiclesUseCase(repo: vehicleRepository)
        self.updateVehicle = UpdateVehicleUseCase(repository: vehicleRepository)
        self.makeEmptyVehicle = MakeEmptyVehicleUseCase(repo: vehicleRepository)
        self.vehicle = makeEmptyVehicle.execute()
    }
    
    func loadVehicle() {
        vehicles = getVehicles.execute()
    }
    
    func upadteVehicle() {
        updateVehicle.execute(vehicle: vehicle)
        loadVehicle()
    }
    
    
    
    
    
}
