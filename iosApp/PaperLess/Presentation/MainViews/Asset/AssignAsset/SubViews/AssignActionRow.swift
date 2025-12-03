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
    
    var body: some View {
            HStack(spacing: 12) {
                RowIcon(icon: "person.crop.circle.badge.plus")
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .modifier(TitleModi())
//                        .foregroundStyle(Color.primary)
//                        .font(.system(size: 17))
                        .fontWeight(.bold)
                    Text(subtitle)
                        .modifier(SubtitleModi())
                }
            }
            .padding(.vertical, 4)
        
    }
}
