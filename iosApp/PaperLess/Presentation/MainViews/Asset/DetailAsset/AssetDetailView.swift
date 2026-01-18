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
    @Environment(\.dismiss) private var dismiss
    @StateViewModel var assetDetailVM = AssetDetailViewModel()
    
    let asset: NfcTaggable
    var onSaved: ((NfcTaggable) -> Void)? = nil 
    @State private var isEditSheetPresented = false
    
    private func reload() {
        assetDetailVM.start(assetId: asset.id)
    }
    
    private var displayedAsset: NfcTaggable {
        assetDetailVM.uiState.asset ?? asset
    }
    
    var body: some View {
        NavigationStack {
            List {
                AssetGeneralInfoSection(asset: displayedAsset)
                AssetCurrentAssignmentSection(
                    isLoading: assetDetailVM.uiState.isLoading,
                    currentAssigneeName: assetDetailVM.uiState.currentAssigneeName,
                    currentAssigneeId: assetDetailVM.uiState.currentAssigneeId,
                    currentAssignmentNote: assetDetailVM.uiState.currentAssignmentNote,
                    asset: displayedAsset
                )
                AssetHistorySection(
                    lastAssignments: assetDetailVM.uiState.lastAssignments,
                    lastAssignees: assetDetailVM.uiState.lastAssignees
                )
            }
            .modifier(ListStyle())
            .standardToolbar(
                title: assetDetailVM.uiState.asset?.name ?? "",
                leadingAction: { dismiss() },
                leadingIcon: "arrow.left.circle",
                trailingAction: { isEditSheetPresented.toggle() },
                trailingIcon: "slider.horizontal.3"
            )
            .sheet(isPresented: $isEditSheetPresented, onDismiss: reload) {
                EditAssetSheet(asset: asset)
                    .presentationDetents([.medium])
            }
            .onAppear {
                assetDetailVM.start(assetId: asset.id)
            }
            .onChange(of: assetDetailVM.uiState.operationSucceeded) { _, operationSucceeded in
                if operationSucceeded {
                    let updated = assetDetailVM.uiState.asset ?? asset
                    onSaved?(updated)
                    dismiss()
                }
            }
        }
    }
}
