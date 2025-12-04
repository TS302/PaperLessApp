//
//  AssetGeneralInfoSection.swift
//  PaperLess
//
//  Created by Tom Salih on 03.12.25.
//

import SwiftUI
import Shared

struct AssetGeneralInfoSection: View {
    let asset: NfcTaggable
        
    var body: some View {
        Section {
            if let tool = asset as? Tool {
                ToolDetailsSection(asset: tool)
            } else if let key = asset as? KeyRing {
                KeyDetailsSection(asset: key)
            } else if let vehicle = asset as? Vehicle {
                VehicleDetailsSection(asset: vehicle)
            }
        }
    }
}
