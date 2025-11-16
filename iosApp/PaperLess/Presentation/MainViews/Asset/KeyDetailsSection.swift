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
        
        LabeledContent {
            Text(asset.name)
        } label: {
            Text("Bezeichnung:")
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


