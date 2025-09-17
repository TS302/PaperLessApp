//
//  LoadVehiclesUseCase.swift
//  PaperLess
//
//  Created by Tom Salih on 12.06.25.
//

import Foundation

struct LoadVehiclesUseCase {
    private let repo: VehicleRepositoryProtocol
    
    init(repo: VehicleRepositoryProtocol){
        self.repo = repo
    }
    
    func execute() -> [Vehicle] {
        repo.getAllVehicles()
    }
}
