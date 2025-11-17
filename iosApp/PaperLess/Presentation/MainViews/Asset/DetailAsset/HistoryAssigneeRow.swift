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
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primary.opacity(0.08))
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color.primary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(employee.name)
                    .fontWeight(.semibold)
                
                Text("01.01.25/12:00 Uhr - 01.02.25/13:43 Uhr")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
