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
        CustomLabeledContent(label: "Bezeichnung", content: asset.name)
        CustomLabeledContent(label: "Marke", content: asset.brand ?? "")
        CustomLabeledContent(label: "Seriennummer", content: asset.serialNumber ?? "")
        
        HStack {
            CustomLabeledContent(label: "Status", content: asset.tagStatus.displayName)
            
            Spacer()
            
            Image(systemName: "ellipsis.rectangle.fill")
                .foregroundStyle(asset.tagStatus.color)
        }
        
    }
}
