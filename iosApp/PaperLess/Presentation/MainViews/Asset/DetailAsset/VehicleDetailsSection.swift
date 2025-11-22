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
        CustomLabeledContent(label: "Marke", content: asset.brand ?? "")
        CustomLabeledContent(label: "KFZ-Kennzeichen", content: asset.plate ?? "")
        CustomLabeledContent(label: "Status", content: asset.tagStatus.displayName)
    }
}
