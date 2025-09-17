//
//  VehicleFormView.swift
//  PaperLess
//
//  Created by Tom Salih on 08.06.25.
//

import SwiftUI

struct VehicleForm: View {
    @Binding var vehicle: Vehicle
    var kmFormatter: NumberFormatter
    
    var body: some View {
        
        Toggle("Favorit", isOn: $vehicle.isFavorite)
            .toggleStyle(SwitchToggleStyle(tint: .primary))
            .foregroundStyle(Color.primary)
            .listRowBackground(Color.secondary)
        
        HStack {
            FormTextField(value: $vehicle.nfcTag.name, label: "Fahrzeugbezeichnung")
            Image(systemName: ObjectIcon.car.rawValue)
                .foregroundStyle(vehicle.color.color)
        }
        .foregroundStyle(Color.primary)
        .listRowBackground(Color.secondary)
        
        FormTextField(value: $vehicle.brand, label: "Marke")
        
        FormTextField(value: $vehicle.kennzeichen, label: "KFZ Kennzeichen")
        
        HStack {
            TextField(
                "Kilometerstand",
                value: $vehicle.kilometerstand,
                formatter: kmFormatter
            )
            .keyboardType(.numberPad)
            .modifier(TextFieldModi())
            
            Spacer()
            
            Text("KM")
                .modifier(TextFieldModi())
        }
        .padding(.vertical, 6)
        .listRowBackground(Color.secondary)
        
        HStack {
            TextField("Tag ID", text: $vehicle.nfcTag.tagID)
                .keyboardType(.numberPad)
                .modifier(TextFieldModi())
            
            Button {
                
            } label: {
                Image(systemName: "widget.small.badge.plus")
                    .foregroundStyle(Color.primary)
            }
        }
        .padding(.vertical, 5)
        .listRowBackground(Color.secondary)
        
        Picker(selection: $vehicle.nfcTag.status, label:
                HStack {
            Text("Status")
                .font(.callout)
                .fontWeight(.bold)
        }
        ) {
            ForEach(DeviceStatus.allCases) { statusCase in
                HStack {
                    Text(statusCase.localizedName)
                        .font(.callout)
                    
                }
                .tag(statusCase)
            }
        }
        .modifier(ListItem())
        
        Picker(selection: $vehicle.color , label:
                HStack {
            Text("Fahrzeugfarbe")
                .font(.callout)
                .fontWeight(.bold)
        }
        ) {
            ForEach(CarColor.allCases) { statusCase in
                HStack {
                    Text(statusCase.localizedName)
                        .font(.callout)
                    
                }
                .tag(statusCase)
            }
        }
        .modifier(ListItem())
        
        DatePicker(
            selection: $vehicle.lastMaintenance,
            displayedComponents: [.date]
        ) {
            Text("Letzte Inspektion")
                .modifier(TextFieldModi())
            
        }
        .modifier(ListItem())
        
        Picker(selection: $vehicle.serviceInterval , label:
                HStack {
            Text("Serviceintervall")
                .font(.callout)
                .fontWeight(.bold)
        }
        ) {
            ForEach(ServiceInterval.allCases) { statusCase in
                HStack {
                    Text(statusCase.localizedName)
                        .font(.callout)
                    
                }
                .tag(statusCase)
            }
        }
        .modifier(ListItem())
        
    }
}


