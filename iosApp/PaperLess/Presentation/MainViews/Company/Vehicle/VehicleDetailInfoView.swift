//
//  DetailInfoView.swift
//  PaperLess
//
//  Created by Tom Salih on 09.06.25.
//

import SwiftUI

struct VehicleDetailInfoView: View {
    
    @Binding var vehicle: Vehicle
    
    var body: some View {
         
        HStack {
            VStack(alignment: .leading) {
                Text("Fahrzeugbezeichnung")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 2)
                    
                HStack {
                    Text(vehicle.nfcTag.name)
                    Spacer()
                    Image(systemName: "star.fill")
                        .foregroundColor(vehicle.isFavorite ? .yellow : Color.primary.opacity(0.3))
                }
            }
        }
        .modifier(TextFieldModi())
        
        HStack {
            VStack(alignment: .leading) {
                Text("Marke")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 2)
                Text(vehicle.brand)
            }
        }
        .modifier(TextFieldModi())
        
        VStack(alignment: .leading) {
            Text("KFZ-Kennzeichen")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.bottom, 2)
                
            Text(vehicle.kennzeichen)
        }
        .modifier(TextFieldModi())
        
        VStack(alignment: .leading) {
            Text("Fahrzeugfarbe")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.bottom, 2)
                
            HStack {
                Text("\(vehicle.color.rawValue)")
                Spacer()
                Image(systemName: "car.fill")
                    .foregroundStyle(vehicle.color.color)
                
            }
        }
        .modifier(TextFieldModi())
        
        VStack(alignment: .leading) {
            Text("Kilometerstand")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.bottom, 2)
                
            HStack {
                Text("\(vehicle.kilometerstand)")
                Spacer()
                Text("km")
            }
        }
        .modifier(TextFieldModi())
        
        VStack(alignment: .leading) {
            Text("Status")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.bottom, 2)
                
            HStack {
                Text(vehicle.nfcTag.status.localizedName)
                Spacer()
                Image(systemName: "ellipsis.rectangle.fill")
                    .foregroundStyle(vehicle.nfcTag.status.color)
            }
        }
        .modifier(TextFieldModi())
    }
}

#Preview {
    VehicleDetailInfoView(vehicle: .constant(Vehicle(nfcTag: NFCTag(id: UUID(), tagID: "000", name: "VW Golf 7 GTI", status: DeviceStatus.available, icon: ObjectIcon.car.rawValue), brand: "Testmarke", kennzeichen: "TÜ-TS-001", color: CarColor.blue, kilometerstand: 114000, serviceInterval: ServiceInterval.nine, lastMaintenance: Date.now, isFavorite: true)))
        .environmentObject(VehicleListViewModel())
}
