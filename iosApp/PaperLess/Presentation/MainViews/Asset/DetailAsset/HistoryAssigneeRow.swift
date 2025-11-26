//
//  HistoryAssigneeRow.swift
//  PaperLess
//
//  Created by Tom Salih on 17.11.25.
//

import SwiftUI
import Shared

struct HistoryAssigneeRow: View {
    let title: String
    let periodText: String
    
    var body: some View {
        HStack(spacing: 12) {
            RowIcon(icon: "person.crop.circle.badge.clock")
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .modifier(ListRowTitle())
                
                Text(periodText)
                    .modifier(ListRowSubtitle())
            }
        }
        .padding(.vertical, 4)
    }
}
