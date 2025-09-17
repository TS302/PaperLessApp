//
//  VehicleListRow.swift
//  PaperLess
//
//  Created by Tom Salih on 27.06.25.
//

import SwiftUI

struct VehicleListRow: View {
    @Binding var vehicle: Vehicle
    @EnvironmentObject var nfcTagViewModel: CompanyViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading) {
                Text(vehicle.nfcTag.name)
                    .font(.headline)
                HStack {
                    
                    Image(systemName: "widget.small")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                    
                    Text(vehicle.nfcTag.tagID)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
            
            HStack {
                Image(systemName: vehicle.nfcTag.icon)
                Image(systemName: "ellipsis.rectangle.fill")
                    .foregroundStyle(Color(vehicle.nfcTag.status.color))
                Image(systemName: "star.fill")
                    .foregroundColor(vehicle.isFavorite ? .yellow : Color.primary.opacity(0.3))
            }
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                vehicle.isFavorite.toggle()
                nfcTagViewModel.updateVehicle(vehicle: vehicle)
            } label: {
                Label(
                    vehicle.isFavorite ? "Unfavorite" : "Favorite",
                    systemImage: vehicle.isFavorite ? "star.slash" : "star.fill"
                        
                )
                .foregroundStyle(Color.yellow)
            }
            .tint(.appYellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                nfcTagViewModel.deleteVehicle(id: vehicle.id)
            } label: {
                Label("Löschen", systemImage: "trash")
            }
            .tint(.error)
        }
    }
}

