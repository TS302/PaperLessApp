//
//  ServiceIntervall.swift
//  PaperLess
//
//  Created by Tom Salih on 03.06.25.
//

import SwiftUI

enum ServiceInterval: Int, Codable, CaseIterable, Identifiable {
    case three   = 3
    case six     = 6
    case nine    = 9
    case twelve  = 12

    var id: Int { rawValue }

    var localizedName: String {
        switch self {
        case .three:   return "3 Monate"
        case .six:     return "6 Monate"
        case .nine:    return "9 Monate"
        case .twelve:  return "12 Monate"
        }
    }
}
