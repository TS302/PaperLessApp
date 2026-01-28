//
//  AssetUserView.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync


struct AssetUserView: View {
    @StateViewModel var assetUserVM = AssetUsersViewModel()
    
    @State private var searchText: String = ""
    @State private var addEmployeeSheetIsPresent: Bool = false
    
    private func delete(_ assetUser: AssetUser) {
        assetUserVM.delete(employeeId: assetUser.id)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(assetUserVM.uiState.items, id: \.idString) { assetUser in
                        NavigationLink {
                            AssetUserDetailView(employeeId: assetUser.idString)
                        } label: {
                            AssetUserRow(assetUser: assetUser)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                delete(assetUser)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                } header: {
                    SectionHeader(text: "Asset-Nutzer")
                }
                
            }
            .modifier(ListStyle())
            .standardToolbar(
                trailingAction: { addEmployeeSheetIsPresent.toggle() },
                trailingIcon: "plus"
            )
        }
        .sheet(isPresented: $addEmployeeSheetIsPresent) {
            AddAssetUserSheet()
                .presentationDetents([.medium])
        }
        .searchable(text: $searchText, prompt: Text("Suchen"))
        .onChange(of: searchText) { _, newValue in
            assetUserVM.setSearchQueryForIos(searchText: newValue)
        }
    }
}
