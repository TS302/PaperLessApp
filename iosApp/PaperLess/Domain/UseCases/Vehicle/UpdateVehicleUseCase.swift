//
//  UpdateVehicleUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 16.06.25.
//

import Foundation

struct UpdateVehicleUseCase {
    private var repository: VehicleRepositoryProtocol
    init(repository: VehicleRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(vehicle: Vehicle) {
        repository.updateVehicle(vehicle: vehicle)
    }
}
