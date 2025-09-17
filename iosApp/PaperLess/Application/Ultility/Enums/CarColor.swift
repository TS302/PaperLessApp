//
//  CarColor.swift
//  PaperLess
//
//  Created by Tom Salih on 03.06.25.
//

import SwiftUI

enum CarColor: String, Codable, CaseIterable, Identifiable {
    case blue = "Blau"
    case yellow = "Gelb"
    case green = "Grün"
    case red = "Rot"
    case black = "Schwarz"
    case white = "Weiß"
    
    var id: Self { self }
    
    var localizedName: String {
        switch self {
        case .blue: return "Blau"
        case .yellow: return "Gelb"
        case .green: return "Grün"
        case .red: return "Rot"
        case .black: return "Schwarz"
        case .white: return "Weiß"
        }
    }
            
    var color: Color {
        switch self {
        case .blue: return .blue
        case .yellow: return .yellow
        case .green: return .green
        case .red: return .red
        case .black: return .black
        case .white: return .white
        }
    }
}

