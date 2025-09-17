//
//  KeyListRow.swift
//  PaperLess
//
//  Created by Tom Salih on 28.06.25.
//

import SwiftUI

struct KeyListRow: View {
    @Binding var key: Key
    @EnvironmentObject var nfcTagViewModel: CompanyViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading) {
                Text(key.nfcTag.name)
                    .font(.headline)
                HStack {
                    Image(systemName: "widget.small")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                    
                    Text(key.nfcTag.tagID)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
            
            HStack {
                Image(systemName: key.nfcTag.icon)
                Image(systemName: "ellipsis.rectangle.fill")
                    .foregroundStyle(Color(key.nfcTag.status.color))
                Image(systemName: "star.fill")
                    .foregroundColor(key.isFavorite ? .yellow : Color.primary.opacity(0.3))
            }
        }
        .modifier(ListStyle(title: ""))
        .scrollContentBackground(.hidden)
        .background(Color.appSecondary)
        .padding(.vertical, 8)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                key.isFavorite.toggle()
                nfcTagViewModel.updateKey(key: key)
            } label: {
                Label(
                    key.isFavorite ? "Unfavorite" : "Favorite",
                    systemImage: key.isFavorite ? "star.slash" : "star.fill"
                )
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                nfcTagViewModel.deleteKey(id: key.id)
            } label: {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}


#Preview {
    
}

