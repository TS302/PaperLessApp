//
//  DeviceStatus.swift
//  PaperLess
//
//  Created by Tom Salih on 03.06.25.
//

import SwiftUI

enum DeviceStatus: String, Codable, CaseIterable, Identifiable {
    case available = "available"
    case loaned    = "loaned"
    case lost      = "lost"
    case defect    = "defect"
    
    var id: Self { self }
    
    var localizedName: String {
        switch self {
        case .available: return "Verfügbar"
        case .loaned:    return "Verliehen"
        case .lost:      return "Verloren"
        case .defect:    return "Defekt"
        }
    }
    
    var color: Color {
        switch self {
        case .available: return .green
        case .loaned:    return .blue
        case .lost:      return .gray
        case .defect:    return .red
        }
    }
}
