//
//  NoAssignedAssetsView.swift
//  PaperLess
//
//  Created by Tom Salih on 20.11.25.
//

import SwiftUI

struct NoAssignedAssetsView: View {
    let title: String
    let description: String
    let icon: String
    var body: some View {
        ContentUnavailableView {
            Label {
                Text(title)
                    .modifier(ListRowTitle())
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(Color.primary)
            }
        } description: {
            Text(description)
                .modifier(ListRowSubtitle())
        }
    }
}
