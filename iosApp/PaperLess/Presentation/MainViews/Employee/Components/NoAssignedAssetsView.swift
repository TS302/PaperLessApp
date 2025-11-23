//
//  NoAssignedAssetsView.swift
//  PaperLess
//
//  Created by Tom Salih on 20.11.25.
//

import SwiftUI

struct NoAssignedAssetsView: View {
    var body: some View {
        ContentUnavailableView {
            Label {
                Text("Keine Items zugewiesen")
                    .modifier(ListRowTitle())
            } icon: {
                Image(systemName: "shippingbox")
                    .foregroundStyle(Color.primary)
            }
        } description: {
            Text("Diesem Mitarbeiter sind aktuell keine Assets zugewiesen.")
                .modifier(ListRowSubtitle())
        }
    }
}
