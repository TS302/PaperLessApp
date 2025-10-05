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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primary.opacity(0.2))
                        
                    item.targetType.icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color.primary)
                }
                
                
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
                .padding(.leading, 2)
            }
        }
        .padding(.vertical, 4)
    }
}
