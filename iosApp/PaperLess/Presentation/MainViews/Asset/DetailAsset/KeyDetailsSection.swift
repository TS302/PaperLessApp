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
        CustomLabeledContent(label: "Status", content: asset.tagStatus.displayName)
    }
}


