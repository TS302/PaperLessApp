//
//  ItemRow.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

import SwiftUI
import Shared

struct ItemRow: View {
    var item: NfcTaggable
    
    var body: some View {
        HStack {
            HStack {
                item.targetType.icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color.primary)
                    .padding(.trailing, 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .modifier(ListRowTitle())
                    
                    HStack {
                        Image(systemName: "ellipsis.rectangle.fill")
                            .foregroundStyle(item.tagStatus.color)
                        Text(item.tagStatus.displayName)
                            .modifier(ListRowSubtitle())
                    }
                }
            }
            
            Spacer()
            Text(item.targetType.name)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
