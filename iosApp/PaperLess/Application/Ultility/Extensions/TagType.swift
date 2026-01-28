//
//  TagType.swift
//  PaperLess
//
//  Created by Tom Salih on 23.01.26.
//

import Shared

extension TagType {
    var systemImageName: String {
        switch self {
        case .vehicle:   return "car.fill"
        case .tool:      return "wrench.and.screwdriver.fill"
        case .key:       return "key.2.on.ring.fill"
        case .assetuser: return "person.2.fill"
        default:         return "tag.fill"
        }
    }
}
