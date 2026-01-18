//
//  HeaderSection.swift
//  PaperLess
//
//  Created by Tom Salih on 28.11.25.
//

import SwiftUI

struct AssignAssetHeaderSection: View {
    let assetName: String?
    
    var body: some View {
        Section {
            VStack(alignment: .center, spacing: 8) {
                Text("Asset-Nutzer auswählen")
                    .modifier(HeadlineModi())
                
                Text("Du kannst anschließend \"\(assetName ?? "Asset")\" übergeben.")
                    .font(.footnote)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 12)
            
        }
    }
    
}
