//
//  HistoryAssigneeRow.swift
//  PaperLess
//
//  Created by Tom Salih on 17.11.25.
//

import SwiftUI
import Shared

struct HistoryAssigneeRow: View {
    let employee: Employee
    
    var body: some View {
        HStack(spacing: 12) {
            RowIcon(icon: "person.crop.circle.badge.clock")
            
            VStack(alignment: .leading, spacing: 2) {
                Text(employee.name)
                    .modifier(ListRowTitle())
                
                Text("01.01.25/12:00 Uhr - 01.02.25/13:43 Uhr")
                    .modifier(ListRowSubtitle())
            }
        }
        .padding(.vertical, 4)
    }
}
