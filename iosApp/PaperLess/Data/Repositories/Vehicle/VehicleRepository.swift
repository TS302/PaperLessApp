//
//  VehicleRepository.swift
//  PaperLess
//
//  Created by Tom Salih on 12.06.25.
//

import SwiftUI

class VehicleRepository: VehicleRepositoryProtocol {
    
    static let shared = VehicleRepository()
    private init(){ }
    
    private var vehicles: [Vehicle] = [
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "001", name: "Porsche 911",
                status: DeviceStatus.available, icon: ObjectIcon.car.rawValue
            ),
            brand: "Porsche", kennzeichen: "TÜ-TS-001",
            color: CarColor.blue, kilometerstand: 10000,
            serviceInterval: .twelve, lastMaintenance: Date.now, isFavorite: true),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "003", name: "BMW M3",
                status: DeviceStatus.available, icon: ObjectIcon.car.rawValue
            ),
            brand: "BMW", kennzeichen: "M-BM-303",
            color: .red, kilometerstand: 20000,
            serviceInterval: .six, lastMaintenance: Date(), isFavorite: true
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "004", name: "Mercedes C-Klasse",
                status: .available, icon: ObjectIcon.car.rawValue
            ),
            brand: "Mercedes", kennzeichen: "S-MB-404",
            color: .black, kilometerstand: 12000,
            serviceInterval: .twelve, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "005", name: "VW Golf",
                status: .loaned, icon: ObjectIcon.car.rawValue
            ),
            brand: "Volkswagen", kennzeichen: "W-VD-505",
            color: .blue, kilometerstand: 30000,
            serviceInterval: .three, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "006", name: "Opel Astra",
                status: .available, icon: ObjectIcon.car.rawValue
            ),
            brand: "Opel", kennzeichen: "B-OP-606",
            color: .green, kilometerstand: 25000,
            serviceInterval: .nine, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "007", name: "Ford Focus",
                status: .loaned, icon: ObjectIcon.car.rawValue
            ),
            brand: "Ford", kennzeichen: "K-FD-707",
            color: .white, kilometerstand: 18000,
            serviceInterval: .six, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "008", name: "Toyota Corolla",
                status: .available, icon: ObjectIcon.car.rawValue
            ),
            brand: "Toyota", kennzeichen: "HH-TY-808",
            color: .yellow, kilometerstand: 22000,
            serviceInterval: .twelve, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "009", name: "Honda Civic",
                status: .defect, icon: ObjectIcon.car.rawValue
            ),
            brand: "Honda", kennzeichen: "F‐HN‐909",
            color: .black, kilometerstand: 27000,
            serviceInterval: .three, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "010", name: "Nissan Qashqai",
                status: .available, icon: ObjectIcon.car.rawValue
            ),
            brand: "Nissan", kennzeichen: "D-NS-010",
            color: .red, kilometerstand: 16000,
            serviceInterval: .nine, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "011", name: "Mazda 3",
                status: .loaned, icon: ObjectIcon.car.rawValue
            ),
            brand: "Mazda", kennzeichen: "MZ-11-011",
            color: .blue, kilometerstand: 14000,
            serviceInterval: .six, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "012", name: "Škoda Octavia",
                status: .available, icon: ObjectIcon.car.rawValue
            ),
            brand: "Škoda", kennzeichen: "B-SK-012",
            color: .red, kilometerstand: 32000,
            serviceInterval: .twelve, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "013", name: "SEAT Leon",
                status: .available, icon: ObjectIcon.car.rawValue
            ),
            brand: "Seat", kennzeichen: "E-SE-013",
            color: .green, kilometerstand: 21000,
            serviceInterval: .three, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "014", name: "Peugeot 308",
                status: .loaned, icon: ObjectIcon.car.rawValue
            ),
            brand: "Peugeot", kennzeichen: "P-PE-014",
            color: .white, kilometerstand: 19500,
            serviceInterval: .nine, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "015", name: "Renault Clio",
                status: .defect, icon: ObjectIcon.car.rawValue
            ),
            brand: "Renault", kennzeichen: "R-RE-015",
            color: .blue, kilometerstand: 29000,
            serviceInterval: .six, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "016", name: "Citroën C3",
                status: .available, icon: ObjectIcon.car.rawValue
            ),
            brand: "Citroën", kennzeichen: "C-CI-016",
            color: .yellow, kilometerstand: 13500,
            serviceInterval: .twelve, lastMaintenance: Date(), isFavorite: false
        ),
        Vehicle(
            nfcTag: NFCTag(
                id: UUID(), tagID: "017", name: "Fiat 500",
                status: .loaned, icon: ObjectIcon.car.rawValue
            ),
            brand: "Fiat", kennzeichen: "T-FI-017",
            color: .blue, kilometerstand:  8000,
            serviceInterval: .three, lastMaintenance: Date(), isFavorite: false
        )
    ]
    
    func getAllVehicles() -> [Vehicle] {
        return vehicles
    }
    
    func addVehicle(newVehicle: Vehicle) {
        vehicles.append(newVehicle)
    }
    
    func updateVehicle(vehicle: Vehicle) {
        if let index = vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicles[index] = vehicle
        }
    }
    
    func deleteVehicle(id: UUID) {
        vehicles.removeAll { $0.id == id }
    }
    
    func makeEmptyVehicle() -> Vehicle {
        return Vehicle(
            nfcTag: NFCTag(
                id: UUID(),
                tagID: "",
                name: "",
                status: .available,
                icon: ObjectIcon.car.rawValue
            ),
            brand: "",
            kennzeichen: "",
            color: .blue,
            kilometerstand: 0,
            serviceInterval: .twelve,
            lastMaintenance: Date.now,
            isFavorite: true
        )
    }
    
    
}

