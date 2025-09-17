//
//  AddNFCTag.swift
//  PaperLess
//
//  Created by Tom Salih on 24.05.25.
//

import SwiftUI

struct AddVehicleView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var addVehicleViewModel = AddVehicleViewModel()
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Neues Fahrzeug")
                    .padding(.top, 20)
                    .font(.system(size: 30, weight: .black))
                    .modifier(TextFieldModi())
                    
            Spacer()
                Button {
                    addVehicleViewModel.emptyNewVehicle()
                    dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .padding(.top, 30)
                        .foregroundStyle(Color.error)
                }
            }
            .padding(.horizontal, 30)
            
            List {
                VehicleForm(vehicle: $addVehicleViewModel.vehicle, kmFormatter: Formatters.kmFormatter)
            }
            .modifier(ListStyle(title: ""))
            
            Button {
                addVehicleViewModel.addVehicle(vehicle: addVehicleViewModel.vehicle)
                addVehicleViewModel.emptyNewVehicle()
                dismiss()
            } label: {
                Text("Speichern")
                    .font(.callout)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.secondary)
                    .padding(10)
                    .background(Color.primary)
                    .cornerRadius(6)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
            }
        }
        .background(Color.secondary)
    }
}


#Preview {
    AddVehicleView()
        .environmentObject(VehicleListViewModel())
}
