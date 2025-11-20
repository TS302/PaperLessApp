//
//  NoAssignedAssetsView.swift
//  PaperLess
//
//  Created by Tom Salih on 20.11.25.
//

import SwiftUI

struct NoAssignedAssetsView: View {
    var body: some View {
        ContentUnavailableView(
            "Keine Items zugewiesen",
            systemImage: "shippingbox",
            description: Text("Diesem Mitarbeiter sind aktuell keine Assets zugewiesen.")
        )
        .foregroundStyle(Color.primary)
    }
}
