//
//  ItemRow.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

import SwiftUI
import Shared

struct AssetRow: View {
    var asset: NfcTaggable
    
    var body: some View {
        HStack {
            HStack {
                RowIcon(icon: asset.tagType.systemImageName)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(asset.name)
                        .modifier(TitleModi())
                    
                    HStack {
                        Image(systemName: "ellipsis.rectangle.fill")
                            .foregroundStyle(asset.tagStatus.color)
                        
                        Text(asset.tagStatus.displayName)
                            .modifier(SubtitleModi())
                    }
                }
                .padding(.leading, 2)
            }
        }
//        .padding(.vertical, 2)
    }
}
