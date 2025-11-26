//
//  AssignActionRow.swift
//  PaperLess
//
//  Created by Tom Salih on 17.11.25.
//

import SwiftUI

struct AssignActionRow: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                RowIcon(icon: "person.crop.circle.badge.plus")
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .modifier(ListRowTitle())
                    Text(subtitle)
                        .modifier(ListRowSubtitle())
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        
    }
}
