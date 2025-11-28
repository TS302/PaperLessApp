//
//  ConfirmAssignDetailsSection.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//

import SwiftUI

struct ConfirmAssignDetailsSection: View {
    let assetName: String
    let fromName: String
    let toName: String

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 4) {
                Text("Asset")
                    .modifier(ListRowSubtitle())
                Text(assetName)
                    .modifier(ListRowTitle())
            }
            .padding(.vertical, 4)
            VStack(alignment: .leading, spacing: 4) {
                Text("Von Name")
                    .modifier(ListRowSubtitle())
                Text(fromName)
                    .modifier(ListRowTitle())
            }
            .padding(.vertical, 4)
            VStack(alignment: .leading, spacing: 4) {
                Text("An Name")
                    .modifier(ListRowSubtitle())
                Text(toName)
                    .modifier(ListRowTitle())
            }
            .padding(.vertical, 4)
        }
    }
}
