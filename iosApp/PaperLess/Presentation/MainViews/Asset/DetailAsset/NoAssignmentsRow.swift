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
            RowIcon(icon: "clock.arrow.circlepath")
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Keine bisherigen Zuweisungen")
                    .modifier(TitleModi())
                Text("Hier siehst du später die letzten Mitarbeiter.")
                    .modifier(SubtitleModi())
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
