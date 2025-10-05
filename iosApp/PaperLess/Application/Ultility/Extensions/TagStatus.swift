//
//  TagStatus.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

import SwiftUI
import Shared

extension TagStatus: @retroactive Identifiable {
    public var id: String { caseName }
    var label: String { displayName }
    var color: Color {
        switch self {
        case .available:
            return .green
        case .inuse:
            return .orange
        case .passive:
            return .error
        default:
            return .black
        }
    }
    static var all: [TagStatus] { [.available, .inuse, .passive]
    }
}
