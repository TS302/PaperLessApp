//
//  AddObjectMenu.swift
//  PaperLess
//
//  Created by Tom Salih on 07.06.25.
//

import SwiftUI

struct AddAssetMenu: View {
    @Binding var showAddVehicle: Bool
    @Binding var showAddTool: Bool
    @Binding var showAddKey: Bool
    
    var body: some View {
        Menu {
            Button { showAddVehicle.toggle() } label: {
                HStack {
                    Image(systemName: ObjectIcon.car.rawValue)
                        .fontWeight(.bold)
                    Text("Fahrzeug hinzufügen")
                }
            }
            
            Button { showAddTool.toggle() } label: {
                HStack {
                    Image(systemName: ObjectIcon.tool.rawValue)
                        .fontWeight(.bold)
                    Text("Tool hinzufügen")
                }
            }
            
            Button { showAddKey.toggle() } label: {
                HStack {
                    Image(systemName: ObjectIcon.key.rawValue)
                        .fontWeight(.bold)
                    Text("Schlüssel hinzufügen")
                }
            }
        } label: {
            Image(systemName: "widget.small.badge.plus")
                .fontWeight(.bold)
        }
        .tint(Color.appPrimary)
    }
}


