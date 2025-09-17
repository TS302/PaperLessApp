//
//  NfcView.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct CompanyView: View {
    @EnvironmentObject var companyViewModel: CompanyViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    switch companyViewModel.selectedSegment {
                        
                    case 0:
                        
                        ForEach($companyViewModel.vehicles) { $vehicles in
                            NavigationLink {
                                VehicleDetailView(vehicle: $vehicles)
                            } label: {
                                VehicleListRow(vehicle: $vehicles)
                            }
                        }
                        .listRowBackground(Color.secondary)
                        
                    case 1:
                        ForEach($companyViewModel.tools) { $tool in
                            NavigationLink {
                                ToolDetailView(tool: $tool)
                            } label: {
                                ToolListRow(tool: $tool)
                            }
                        }
                        .listRowBackground(Color.secondary)
                        
                    case 2:
                        ForEach($companyViewModel.keys) { $key in
                            NavigationLink {
                                KeyDetailView(key: $key)
                            } label: {
                                KeyListRow(key: $key)
                            }
                        }
                        .listRowBackground(Color.secondary)
                        
                    default:
                        EmptyView()
                    }
                } header: {
                    HStack {
                        CompanyListHeadline(selectedSegment: $companyViewModel.selectedSegment)
                        Spacer()
                        FavoriteNFCTagSegmentPicker(selectedSegment: $companyViewModel.selectedSegment)
                    }
                }
            }
            .onAppear {
                companyViewModel.loadVehicles()
                companyViewModel.loadTools()
                companyViewModel.loadKeys()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddObjectMenu(
                        showAddVehicle: $companyViewModel.showAddVehicle,
                        showAddTool: $companyViewModel.showAddTool,
                        showAddKey: $companyViewModel.showAddKey
                    )
                }
            }
            .sheet(isPresented: $companyViewModel.showAddVehicle) {
                AddVehicleView()
            }
            .searchable(text: $companyViewModel.searchText, prompt: "Suchen")
            .modifier(ListStyle(title: "Firma"))
        }
        .background(Color.primary)
    }
}

#Preview {
    CompanyView()
}
