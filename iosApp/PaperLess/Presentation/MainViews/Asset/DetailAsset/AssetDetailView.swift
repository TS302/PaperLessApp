//
//  AssetDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AssetDetailView: View {
    let asset: NfcTaggable
    var onSaved: ((NfcTaggable) -> Void)? = nil
    
    @StateViewModel var itemDetailVM = AssetDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditSheetPresented = false
    @State private var isAssignSheetPresented = false
    
    private func reload() {
        itemDetailVM.load(assetId: asset.id)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let displayedAsset = itemDetailVM.uiState.asset ?? asset
                    
                    if let tool = displayedAsset as? Tool {
                        ToolDetailsSection(asset: tool)
                    } else if let key = displayedAsset as? KeyRing {
                        KeyDetailsSection(asset: key)
                    } else if let vehicle = displayedAsset as? Vehicle {
                        VehicleDetailsSection(asset: vehicle)
                    }
                } header: {
                    SectionHeader(text: "Allgemeine Informationen")
                }
                
                Section {
                    
                    if itemDetailVM.uiState.isLoading {
                        ProgressView("Zuweisung wird geladen…")
                        
                    } else if
                        let currentName = itemDetailVM.uiState.currentAssigneeName,
                        !currentName.isEmpty
                    {
                        if let currentEmployeeId = itemDetailVM.uiState.currentAssigneeId {
                            NavigationLink {
                                EmployeeDetailView(employeeId: currentEmployeeId)
                            } label: {
                                CurrentAssigneeRow(name: currentName)
                            }
                        }
                        AssignActionRow(
                            title: "Neue Zuweisung",
                            subtitle: "Dieses Objekt einer anderen Person zuordnen.",
                            action: { isAssignSheetPresented = true }
                        )
                    } else {
                        AssignActionRow(
                            title: "Mitarbeiter zuweisen",
                            subtitle: "Dieses Objekt ist aktuell niemandem zugeordnet.",
                            action: { isAssignSheetPresented = true }
                        )
                    }
                } header: {
                    SectionHeader(text: "Aktuelle Zuweisung")
                }
                
                Section {
                    if itemDetailVM.uiState.lastAssignees.isEmpty {
                        NoAssignmentsRow()
                    } else {
                        ForEach(itemDetailVM.uiState.lastAssignees, id: \.id) { employee in
                            HistoryAssigneeRow(employee: employee)
                        }
                    }
                } header: {
                    SectionHeader(text: "Vergangene Zuweisungen")
                }
            }
            .modifier(ListStyle(title: asset.name))
            .sheet(isPresented: $isAssignSheetPresented,onDismiss: reload) {
                AssignAssetSheet(
                    itemIdString: asset.id.description(),
                    onClose: { isAssignSheetPresented = false }
                )
            }
            .sheet(isPresented: $isEditSheetPresented, onDismiss: reload) {
                EditAssetSheet(asset: asset)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isEditSheetPresented.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .onAppear {
                itemDetailVM.load(assetId: asset.id)
            }
            .onChange(of: itemDetailVM.uiState.operationSucceeded) { _, operationSucceeded in
                if operationSucceeded {
                    let updated = itemDetailVM.uiState.asset ?? asset
                    onSaved?(updated)
                    dismiss()
                }
            }
        }
    }
}
