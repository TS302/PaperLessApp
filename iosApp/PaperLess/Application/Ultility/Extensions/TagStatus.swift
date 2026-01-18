//
//  TagStatus.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

import SwiftUI
import Shared

extension TagStatus {

    static func fromFirestore(_ value: String?) -> TagStatus {
        guard let value else {
            return .available
        }
        
        switch value {
        case TagStatus.available.caseName:
            return .available
        case TagStatus.inuse.caseName:
            return .inuse
        case TagStatus.passive.caseName:
            return .passive
        default:
            return .available
        }
    }
}

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
