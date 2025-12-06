//
//  Employee.swift
//  PaperLess
//
//  Created by Tom Salih on 12.11.25.
//

import Shared

extension AssetUser: @retroactive Identifiable {
    var idString: String {
        String(describing: id)
    }
}

extension AssetUser {
    func matches(query: String) -> Bool {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return true }

        let q = trimmed.lowercased()
        return name.lowercased().contains(q)
            || email.lowercased().contains(q)
    }
}
