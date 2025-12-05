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
    @StateViewModel var itemDetailVM = AssetDetailViewModel()
    
    let asset: NfcTaggable
    var onSaved: ((NfcTaggable) -> Void)? = nil
    @State private var isEditSheetPresented = false
    
    private func reload() {
        itemDetailVM.load(assetId: asset.id)
    }
    
    private var displayedAsset: NfcTaggable {
        itemDetailVM.uiState.asset ?? asset
    }
    
    var body: some View {
        NavigationStack {
            List {
                AssetGeneralInfoSection(asset: displayedAsset)
                AssetCurrentAssignmentSection(
                    isLoading: itemDetailVM.uiState.isLoading,
                    currentAssigneeName: itemDetailVM.uiState.currentAssigneeName,
                    currentAssigneeId: itemDetailVM.uiState.currentAssigneeId,
                    currentAssignmentNote: itemDetailVM.uiState.currentAssignmentNote,
                    assetIdString: itemDetailVM.uiState.asset?.idString ?? ""
                )
                AssetHistorySection(
                    lastAssignments: itemDetailVM.uiState.lastAssignments,
                    lastAssignees: itemDetailVM.uiState.lastAssignees
                )
            }
            .modifier(ListStyle())
            .standardToolbar(
                title: itemDetailVM.uiState.asset?.name ?? "",
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
