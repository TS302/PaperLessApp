//
//  FavoriteNFCTagSegmentPicker.swift
//  PaperLess
//
//  Created by Tom Salih on 23.06.25.
//

import SwiftUI
import Shared

struct FilterPicker: View {
    @Binding var filter: TagType?

    var body: some View {
        HStack {
            Text(filter?.displayName ?? "Alle")
                .font(.callout)
                .fontWeight(.black)
                .foregroundStyle(Color.primary)
            
            Spacer()

            Button {
                filter = .vehicle
            } label: {
                Image(systemName: TagType.vehicle.systemImageName)
                    .padding(.trailing, 10)
                    .font(.system(size: 16))
                    .foregroundColor(filter == .vehicle ? .primary : .primary.opacity(0.4))
            }
            .accessibilityLabel("Fahrzeuge")

            Button {
                filter = .tool
            } label: {
                Image(systemName: TagType.tool.systemImageName)
                    .padding(.trailing, 10)
                    .font(.system(size: 16))
                    .foregroundColor(filter == .tool ? .primary : .primary.opacity(0.4))
            }
            .accessibilityLabel("Werkzeuge")

            Button {
                filter = .key
            } label: {
                Image(systemName: "key.2.on.ring.fill")
                    .font(.system(size: 16))
                    .foregroundColor(filter == .key ? .primary : .primary.opacity(0.4))
            }
            .accessibilityLabel("Schlüssel")
            
            Button {
                filter = nil
            } label: {
                Image(systemName: "x.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color.error)
                    .opacity(0.8)
            }
            .accessibilityLabel("Filter löschen")

        }
        .frame(maxWidth: .infinity, minHeight: 30, alignment: .trailing)
        .padding(.bottom, 8)
    }
}

#Preview {
    FilterPicker(filter: .constant(.vehicle))
}
