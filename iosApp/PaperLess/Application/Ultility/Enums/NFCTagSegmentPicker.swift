//
//  NFCTagSegmentPicker.swift
//  PaperLess
//
//  Created by Tom Salih on 07.06.25.
//

import SwiftUI

enum NFCTagSegmentPicker: Int, Codable, CaseIterable, Identifiable {
    case vehicle   = 1
    case tool     = 2
    case key    = 3

    var id: Int { rawValue }

    var localizedName: String {
        switch self {
        case .vehicle:   return "Fahrzeuge"
        case .tool:     return "Tools"
        case .key:    return "Schlüssel"
        }
    }
}
