//
//  Formatters.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import Foundation

struct Formatters {
    static let kmFormatter: NumberFormatter = {
        let input = NumberFormatter()
        input.numberStyle           = .decimal
        input.locale                = Locale(identifier: "de_DE")
        input.allowsFloats          = false
        input.maximumFractionDigits = 0
        input.usesGroupingSeparator = true
        input.isLenient             = true
        input.zeroSymbol            = ""
        
        return input
    }()
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        df.locale     = Locale(identifier: "de_DE")
        return df
    }()

}
