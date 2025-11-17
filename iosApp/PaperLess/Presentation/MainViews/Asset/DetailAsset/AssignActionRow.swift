//
//  AssignActionRow.swift
//  PaperLess
//
//  Created by Tom Salih on 17.11.25.
//

import SwiftUI

struct AssignActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primary.opacity(0.1))
                    
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.primary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                    
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
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
