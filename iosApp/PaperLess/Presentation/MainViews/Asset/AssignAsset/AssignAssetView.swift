//
//  AssignAssetView.swift
//  PaperLess
//
//  Created by Tom Salih on 27.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AssignAssetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var assignAssetVM = AssignAssetViewModel()
    
    @State private var searchText: String = ""
    @State private var selectedEmployeeForDialog: AssetUser?
    @FocusState private var isSearchFocused: Bool
    
    let asset: NfcTaggable
    
    private var assetIdString: String {
        asset.id.description
    }
    
    private var assetName: String {
        let trimmed = asset.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Asset" : trimmed
    }
    
    private var filteredEmployees: [AssetUser] {
        let assetUsers: [AssetUser] = assignAssetVM.uiState.assetUsers
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return assetUsers }
        
        return assetUsers.filter { $0.searchQuery(query: trimmed) }
    }
    
    var body: some View {
        List {
            Section {
                if !isSearchFocused {
                    AssignAssetHeaderSection(assetName: assetName)
                }
            }
            
            Section {
                
                AssignAssetEmployeeListSection(
                    assetUserList: filteredEmployees
                ) { assetUser in
                    assignAssetVM.onEmployeeTapped(assetUser: assetUser)
                    selectedEmployeeForDialog = assetUser
                }
            }
        }
        .modifier(ListStyle())
        .standardToolbar(
            title: assetName,
            leadingAction: { dismiss() },
            leadingIcon: "arrow.left.circle"
        )
        .searchable(text: $searchText, prompt: "Suchen")
        .searchFocused($isSearchFocused)
        .onAppear {
            assignAssetVM.attach(assetIdString: assetIdString)
        }
        .onChange(of: assignAssetVM.uiState.didAssignSuccessfully) { _, success in
            if success {
                dismiss()
                assignAssetVM.resetSuccessFlag()
            }
        }
        .sheet(item: $selectedEmployeeForDialog) { assetUser in
            ConfirmAssignDialogSheet(
                assignAssetVM: assignAssetVM,
                assetUser: assetUser,
                assetId: asset.id.description(),
                assetName: asset.name
            )
        }
    }
}
