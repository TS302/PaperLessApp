//
//  FavoriteNFCTagSegmentPicker.swift
//  PaperLess
//
//  Created by Tom Salih on 23.06.25.
//

import SwiftUI

struct FilterPicker: View {
    @Binding var filter: FilterOption

    var body: some View {
        HStack {
            Text(filter.title)
                .opacity(0.4)
                .font(.callout)
                .fontWeight(.black)
                .foregroundStyle(Color.primary)
            
            Spacer()

            Button {
                filter = .vehicles
            } label: {
                Image(systemName: "car.fill")
                    .padding(.trailing, 10)
                    .font(.system(size: 16))
                    .foregroundColor(filter == .vehicles ? .primary : .primary.opacity(0.4))
            }
            .accessibilityLabel("Fahrzeuge")

            Button {
                filter = .tools
            } label: {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .padding(.trailing, 10)
                    .font(.system(size: 16))
                    .foregroundColor(filter == .tools ? .primary : .primary.opacity(0.4))
            }
            .accessibilityLabel("Werkzeuge")

            Button {
                filter = .keys
            } label: {
                Image(systemName: "key.2.on.ring.fill")
                    .font(.system(size: 16))
                    .foregroundColor(filter == .keys ? .primary : .primary.opacity(0.4))
            }
            .accessibilityLabel("Schlüssel")

            Button {
                filter = .employees
            } label: {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 16))
                    .foregroundColor(filter == .employees ? .primary : .primary.opacity(0.4))
            }
            .accessibilityLabel("Mitarbeiter")
            
            Button {
                filter = .all
            } label: {
                Image(systemName: "x.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color.error)
                    .opacity(0.8)
            }
            .accessibilityLabel("Filter löschen")

        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, 8)
    }
}

#Preview {
    FilterPicker(filter: .constant(.vehicles))
}
