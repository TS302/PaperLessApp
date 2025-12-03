//
//  ItemRow.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

import SwiftUI
import Shared

struct AssetRow: View {
    var item: NfcTaggable
    
    var body: some View {
        HStack {
            HStack {
                RowIcon(icon: item.targetType.systemImageName)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .modifier(TitleModi())
                    
                    HStack {
                        Image(systemName: "ellipsis.rectangle.fill")
                            .foregroundStyle(item.tagStatus.color)
                        
                        Text(item.tagStatus.displayName)
                            .modifier(SubtitleModi())
                    }
                }
                .padding(.leading, 2)
            }
        }
        .padding(.vertical, 2)
    }
}
