//
//  TargetType.swift
//  PaperLess
//
//  Created by Tom Salih on 24.09.25.
//

import SwiftUI
import Shared

extension TagType {
    var asFilterOption: FilterOption {
        switch self {
        case .vehicle: return .vehicles
        case .tool: return .tools
        case .key: return .keys
        case .assetuser: return .assetUser
        default:
            return .vehicles
        }
    }
    
    var systemImageName: String {
        switch self {
        case .vehicle: return "car.fill"
        case .tool: return "wrench.and.screwdriver.fill"
        case .key: return "key.2.on.ring.fill"
        case .assetuser: return "person.fill"
        default:
            return "questionmark.circle"
        }
    }
    
    var icon: Image {
        Image(systemName: systemImageName)
    }
}
