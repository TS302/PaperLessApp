//
//  AssetsView.swift
//  PaperLess
//
//  Created by Tom Salih on 22.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct AssetsView: View {
    @StateViewModel var assetsVM = AssetsViewModel()
    
    @State private var addVehicle = false
    @State private var addTool = false
    @State private var addKey = false
    @State private var searchText: String = ""
    
    private var filterBinding: Binding<TagType?> {
        Binding(
            get: { assetsVM.uiState.activeTypeFilter },
            set: { newValue in
                assetsVM.setTypeFilter(newTypeFilter: newValue)
            }
        )
    }
    
    private var searchBinding: Binding<String> {
        Binding(
            get: { searchText },
            set: { newValue in
                searchText = newValue
                assetsVM.setSearchQuery(newSearchQueryText: newValue)
            }
        )
    }
    
//    private func reloadList() {
//        assetsVM.setTypeFilter(newTypeFilter: filterBinding)
//        assetsVM.setSearchQuery(newSearchQueryText: searchText)
//    }
    
    private func delete(_ item: NfcTaggable) {
        assetsVM.deleteItem(id: item.id)
    }
    
    var body: some View {
        let state = assetsVM.uiState
        NavigationStack {
            List {
                Section {
                    ForEach(state.assets, id: \.id) { asset in
                        NavigationLink {
                            AssetDetailView(asset: asset)
                        } label: {
                            AssetRow(asset: asset)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                delete(asset)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                } header: {
                    FilterPicker(filter: filterBinding)
                }
            }
            .modifier(ListStyle())
            .searchable(text: searchBinding, prompt: "Suchen")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddAssetMenu(
                        showAddVehicle: $addVehicle,
                        showAddTool: $addTool,
                        showAddKey: $addKey
                    )
                }
            }
        }
        .sheet(isPresented: $addVehicle) {
            AddVehicleSheet()
        }
        .sheet(isPresented: $addTool) {
            AddToolSheet()
        }
        .sheet(isPresented: $addKey) {
            AddKeySheet()
        }
    }
}

#Preview {
    AssetsView()
}
