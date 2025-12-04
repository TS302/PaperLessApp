//
//  CurrentAssigneeRow.swift
//  PaperLess
//
//  Created by Tom Salih on 17.11.25.
//

import SwiftUI

struct CurrentAssigneeRow: View {
    let name: String
    let note: String?
    
    var body: some View {
        HStack(spacing: 12) {
            RowIcon(icon: "person.and.background.dotted")
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .modifier(TitleModi())
                
                if let note, !note.isEmpty {
                    Text(note)
                        .modifier(SubtitleModi())
                } else {
                    Text("Aktuell zugeordnet")
                        .modifier(SubtitleModi())
                }
            }
        }
        .padding(.vertical, 4)
    }
}
