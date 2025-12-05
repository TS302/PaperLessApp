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
    
    var body: some View {
        NavigationStack {
            
            Form {
                Section {
                    let displayedAsset = editAssetVM.uiState.asset ?? asset
                    
                    if displayedAsset is Tool {
                        EditToolSection(editAssetVM: editAssetVM)
                    } else if displayedAsset is KeyRing {
                        EditKeySection(editAssetVM: editAssetVM)
                    } else if displayedAsset is Vehicle {
                        EditVehicleSection(editAssetVM: editAssetVM)
                    }
                }
            }
            .modifier(ListStyle())
            .standardToolbar(
                title: asset.name,
                leadingAction: {
                    editAssetVM.reload(assetId: asset.id)
                    dismiss()
                },
                leadingIcon: "xmark.circle",
                trailingAction: { editAssetVM.saveCurrentItem() },
                trailingIcon: "checkmark.circle"
            )
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

