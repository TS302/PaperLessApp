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
        
        LabeledContent {
            Text(asset.name)
        } label: {
            Text("Bezeichnung:")
                .foregroundStyle(.secondary)
        }
                
        LabeledContent {
            Text(asset.brand ?? "n/a")
        } label: {
            Text("Marke:")
                .foregroundStyle(.secondary)
        }
        
        LabeledContent {
            HStack {
                Text(asset.plate ?? "n/a")
            }
        } label: {
            Text("Kennzeichen:")
                .foregroundStyle(.secondary)
        }
        
        LabeledContent {
            HStack {
                Text(asset.tagStatus.displayName)
            }
        } label: {
            Text("Status:")
                .foregroundStyle(.secondary)
        }
    }
}
