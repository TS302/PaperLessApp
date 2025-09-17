//
//  DeleteVehicleUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import Foundation

struct DeleteVehicleUseCase {
    private let repository: VehicleRepositoryProtocol
    init(repo: VehicleRepositoryProtocol) {
        self.repository = repo
    }
    
    func execute(id: UUID) {
        repository.deleteVehicle(id: id)
    }
}
