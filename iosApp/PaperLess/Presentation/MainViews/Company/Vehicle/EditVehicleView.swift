//
//  EditVehicleView.swift
//  PaperLess
//
//  Created by Tom Salih on 09.06.25.
//

import SwiftUI

struct EditVehicleView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var editVehicleViewModel = EditVehicleViewModel()
    
    @Binding var vehicle: Vehicle
    
    var body: some View {
        VStack {

            List {
                VehicleForm(vehicle: $vehicle, kmFormatter: Formatters.kmFormatter)
            }
            Button {
                editVehicleViewModel.updateVehicle(vehicle: vehicle)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary)
        
    }
}
