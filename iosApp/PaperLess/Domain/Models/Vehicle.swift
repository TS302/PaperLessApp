//
//  Vehicle.swift
//  PaperLess
//
//  Created by Tom Salih on 03.06.25.
//

import Foundation
import SwiftUI

class Vehicle: NFCTagProtocol, Identifiable {
    let id: UUID = UUID()
    var nfcTag: NFCTag
    
    var brand: String
    var kennzeichen: String
    var color: CarColor
    var kilometerstand: Int
    var serviceInterval: ServiceInterval
    var lastMaintenance: Date
    var isFavorite: Bool 
    
    init(nfcTag: NFCTag,
         brand: String,
         kennzeichen: String,
         color: CarColor,
         kilometerstand: Int,
         serviceInterval: ServiceInterval,
         lastMaintenance: Date,
         isFavorite: Bool
    ) {
        self.nfcTag = nfcTag
        self.brand = brand
        self.kennzeichen = kennzeichen
        self.color = color
        self.kilometerstand = kilometerstand
        self.serviceInterval = serviceInterval
        self.lastMaintenance = lastMaintenance
        self.isFavorite = isFavorite
    }
}
