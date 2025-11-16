//
//  EditAssetSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 16.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct EditAssetSheet: View {
    let asset: NfcTaggable
    @StateViewModel var editAssetVM = EditAssetSheetViewModel()
    @Environment(\.dismiss) private var dismiss
    
    private var nameBinding: Binding<String> {
        Binding(
            get: { editAssetVM.uiState.asset?.name ?? asset.name },
            set: { editAssetVM.setNameinState(newName: $0) }
        )
    }
    
    private var statusCaseNameBinding: Binding<String> {
        Binding(
            get: { editAssetVM.uiState.asset?.tagStatus.caseName ?? asset.tagStatus.caseName },
            set: { newCaseName in
                if let newStatus = TagStatus.all.first(where: { $0.caseName == newCaseName }) {
                    editAssetVM.setStatusInState(newStatus: newStatus)
                }
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Bezeichnung") {
                    TextField("Bezeichnung", text: nameBinding)
                }
                
                Section("Status") {
                    Picker("Status", selection: statusCaseNameBinding) {
                        ForEach(TagStatus.all, id: \.caseName) { status in
                            HStack {
                                Circle()
                                    .fill(status.color)
                                    .frame(width: 12, height: 12)
                                Text(status.displayName)
                            }
                            .tag(status.caseName)
                        }
                    }
                }
            }
            .navigationTitle("Bearbeiten")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        editAssetVM.reload(assetId: asset.id)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        editAssetVM.saveCurrentItem()
                    }
                }
            }
            .onChange(of: editAssetVM.uiState.operationSucceeded) { _, ok in
                if ok {
                    dismiss()
                }
            }
            .onAppear {
                editAssetVM.start(asset: asset, refresh: false)
            }
            
            
        }
    }
}

