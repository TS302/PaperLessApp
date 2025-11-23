//
//  CurrentAssigneeRow.swift
//  PaperLess
//
//  Created by Tom Salih on 17.11.25.
//

import SwiftUI

struct CurrentAssigneeRow: View {
    let name: String
    
    var body: some View {
        HStack(spacing: 12) {
            RowIcon(icon: "person.and.background.dotted")
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .modifier(ListRowTitle())
                Text("Aktuell zugewiesen")
                    .modifier(ListRowSubtitle())
            }
        }
        .padding(.vertical, 4)
    }
}
