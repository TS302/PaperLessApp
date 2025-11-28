//
//  Employee.swift
//  PaperLess
//
//  Created by Tom Salih on 12.11.25.
//

import Shared

extension Employee: Identifiable {
    var idString: String {
        String(describing: id)
    }
}
