//
//  SortOptions.swift
//  PaperLess
//
//  Created by Tom Salih on 07.06.25.
//

enum SortOption: String, CaseIterable, Identifiable {
    case name, status
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .name:
            return "ABC"
        case .status:
            return "Status"
        }
    }
}
