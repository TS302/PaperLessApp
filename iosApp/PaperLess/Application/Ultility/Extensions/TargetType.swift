//
//  TargetType.swift
//  PaperLess
//
//  Created by Tom Salih on 24.09.25.
//

import SwiftUI
import Shared

extension TargetType {
    var asFilterOption: FilterOption {
        switch self {
        case .vehicle: return .vehicles
        case .tool: return .tools
        case .key: return .keys
        case .employee: return .employees
        default:
            return .vehicles
        }
    }
    
    var systemImageName: String {
        switch self {
        case .vehicle: return "car.fill"
        case .tool: return "wrench.and.screwdriver.fill"
        case .key: return "key.2.on.ring.fill"
        case .employee: return "person.fill"
        default:
            return "questionmark.circle"
        }
    }
    
    var icon: Image {
        Image(systemName: systemImageName)
    }
}
