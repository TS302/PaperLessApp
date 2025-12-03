//
//  ToolDetailsSection.swift
//  PaperLess
//
//  Created by Tom Salih on 16.11.25.
//

import SwiftUI
import Shared

struct ToolDetailsSection: View {
    let asset: Tool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            CustomLabeledContent(label: "Bezeichnung", content: asset.name)
            CustomLabeledContent(label: "Marke", content: asset.brand ?? "Nicht verfügbar")
            CustomLabeledContent(label: "Seriennummer", content: asset.serialNumber ?? "Nicht verfügbar")
            
            HStack {
                CustomLabeledContent(label: "Status", content: asset.tagStatus.displayName)
                Spacer()
                Image(systemName: "ellipsis.rectangle.fill")
                    .foregroundStyle(asset.tagStatus.color)
            }
        }
        
        
    }
}
