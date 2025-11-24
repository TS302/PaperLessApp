//
//  VehicleDetailsSection.swift
//  PaperLess
//
//  Created by Tom Salih on 16.11.25.
//

import SwiftUI
import Shared

struct VehicleDetailsSection: View {
    let asset: Vehicle
    
    var body: some View {
        CustomLabeledContent(label: "Bezeichnung", content: asset.name)
        CustomLabeledContent(label: "Marke", content: asset.brand ?? "Nicht verfügbar")
        CustomLabeledContent(label: "KFZ-Kennzeichen", content: asset.plate ?? "Nicht verfügbar")
        
        HStack {
            CustomLabeledContent(label: "Status", content: asset.tagStatus.displayName)
            
            Spacer()
            
            Image(systemName: "ellipsis.rectangle.fill")
                .foregroundStyle(asset.tagStatus.color)
        }
    }
}
