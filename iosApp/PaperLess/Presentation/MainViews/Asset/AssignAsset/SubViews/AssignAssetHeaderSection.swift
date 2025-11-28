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
            VStack(spacing: 6) {
                HStack(alignment: .center) {
                    Image(systemName: "backpack.sensor.tag.radiowaves.left.and.right.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                        .foregroundStyle(Color.primary)
                }
                .padding(.bottom, 6)
                VStack(alignment: .center) {
                    Text("Bitte einen Asset-Nutzer wählen.")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Du kannst anschließend \"\(assetName ?? "LEER")\" an ihn übergeben.")                            .font(.footnote)
                        .foregroundStyle(Color.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(20)
            .padding(.top, 20)
        }
    }
    
}
