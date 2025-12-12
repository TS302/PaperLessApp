//
//  FilterOption.swift
//  PaperLess
//
//  Created by Tom Salih on 24.09.25.
//

import SwiftUI
import Shared

enum FilterOption: String, CaseIterable, Identifiable {
    case all = "Alle"
    case assetUser = "Asset-User"
    case vehicles = "Fahrzeuge"
    case tools = "Werkzeuge"
    case keys = "Schlüssel"
    
    var id: Self { self }
}

extension FilterOption {
    var toTargetTypeOrNil: TagType? {
        switch self {
        case .all:
            return nil
        case .vehicles:
            return .vehicle
        case .tools:
            return .tool
        case .keys:
            return .key
        case .assetUser:
            return .assetuser
        }
    }
    
    var title: String {
        switch self {
        case .all:       
            return "Alle"
        case .vehicles:  
            return "Fahrzeuge"
        case .tools:     
            return "Werkzeuge"
        case .keys:      
            return "Schlüssel"
        case .assetUser:
            return "Asset-User"
        }
    }
    
    var icon: Image {
        switch self {
        case .all:
            return Image(systemName: "x.circle.fill")
        case .vehicles:
            return Image(systemName: "car.fill")
        case .tools:
            return Image(systemName: "wrench.and.screwdriver.fill")
        case .keys:
            return Image(systemName: "key.2.on.ring.fill")
        case .assetUser:
            return Image(systemName: "person.2.fill")
        }
    }
}


