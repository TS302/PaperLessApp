//
//  VehicleDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 04.06.25.
//

import SwiftUI

struct VehicleDetailView: View {
    @StateObject private var vehicleDetailViewModel = VehicleDetailViewModel()
    @Binding var vehicle: Vehicle
    
    var body: some View {
        
        NavigationStack {
            List {
                SegmentPicker(selectedSegment: $vehicleDetailViewModel.selectedSegment, segmentCount: 2, label1: "Info", label2: "Inspektion", label3: "")
                
                switch vehicleDetailViewModel.selectedSegment {
                    
                case 0:
                    VehicleDetailInfoView(vehicle: $vehicle)
                    
                default:
                    EmptyView()
                }
            }
            .modifier(ListStyle(title: vehicle.nfcTag.name))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        vehicleDetailViewModel.showEditVehicle.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.2.square")
                            .foregroundStyle(Color.primary)
                    }
                }
            }
            .sheet(isPresented: $vehicleDetailViewModel.showEditVehicle, onDismiss: {
                vehicleDetailViewModel.vehicle = vehicle
            }) {
                EditVehicleView(vehicle: $vehicle)
                    .environmentObject(vehicleDetailViewModel)
            }
        }
    }
}


