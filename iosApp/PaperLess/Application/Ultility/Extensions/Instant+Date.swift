//
//  Instant+Date.swift
//  PaperLess
//
//  Created by Tom Salih on 25.11.25.
//

import Foundation
import Shared

// Achtung: Typname genau so schreiben wie Xcode ihn in der Fehlermeldung zeigt
extension Kotlinx_datetimeInstant {
    func toDate() -> Date {
        // epochSeconds + Nanosekunden in Sekunden umrechnen
        let seconds = TimeInterval(self.epochSeconds)
        let nanos = TimeInterval(self.nanosecondsOfSecond) / 1_000_000_000
        return Date(timeIntervalSince1970: seconds + nanos)
    }
}

extension DateFormatter {
    /// Gemeinsamer Formatter für "01.01.25/12:00 Uhr"
    static let assignment: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy/HH:mm 'Uhr'"
        df.locale = Locale(identifier: "de_DE")
        return df
    }()
    
    
    /// Formatter nur für das Datum "01.01.2025"
    static let assignmentDateOnly: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        df.locale = Locale(identifier: "de_DE")
        return df
    }()
}

extension Date {
    /// Komfort-Funktion, um ein Date im Assignment-Stil zu formatieren
    func formattedAsAssignment() -> String {
        DateFormatter.assignment.string(from: self)
    }
    
    /// Nur das Datum im Assignment-Stil, ohne Uhrzeit
    func formattedAssignmentDateOnly() -> String {
        DateFormatter.assignmentDateOnly.string(from: self)
    }
}
