//
//  AddVehicleCase.swift
//  PaperLess
//
//  Created by Tom Salih on 12.06.25.
//

import Foundation

struct AddVehicleUseCase {
    private let repo: VehicleRepositoryProtocol
    init(repo: VehicleRepositoryProtocol) {
        self.repo = repo
    }
    
    func execute(newVehicle: Vehicle) {
        repo.addVehicle(newVehicle: newVehicle)
    }
}
