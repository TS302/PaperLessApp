//
//  NoAssignmentsRow.swift
//  PaperLess
//
//  Created by Tom Salih on 17.11.25.
//

import SwiftUI

struct NoAssignmentsRow: View {
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primary.opacity(0.1))
                
                Image(systemName: "clock.arrow.circlepath")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color.primary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Keine bisherigen Zuweisungen")
                    .foregroundStyle(.secondary)
                Text("Hier siehst du später die letzten Mitarbeiter.")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
