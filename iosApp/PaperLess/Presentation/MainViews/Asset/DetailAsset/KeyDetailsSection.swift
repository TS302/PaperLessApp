//
//  KeyDetailsSection.swift
//  PaperLess
//
//  Created by Tom Salih on 16.11.25.
//

import SwiftUI
import Shared

struct KeyDetailsSection: View {
    let asset: KeyRing
    
    var body: some View {
        CustomLabeledContent(label: "Bezeichnung", content: asset.name)
        CustomLabeledContent(label: "Seriennummer", content: asset.serialNumber ?? "001-001-1001")
        
        HStack {
            CustomLabeledContent(label: "Status", content: asset.tagStatus.displayName)
            
            Spacer()
            
            Image(systemName: "ellipsis.rectangle.fill")
                .foregroundStyle(asset.tagStatus.color)
        }
    }
}


