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

    private var filterBinding: Binding<FilterOption> {
        Binding(
            get: {
                if let filter = assetsVM.uiState.activeTypeFilter { return filter.asFilterOption }
                return .all
            },
            set: { newValue in
                assetsVM.setTypeFilterForIos(typeFilter: newValue.toTargetTypeOrNil)
            }
        )
    }

    private var searchBinding: Binding<String> {
        Binding(
            get: { searchText },
            set: { newValue in
                searchText = newValue
                assetsVM.setSearchQueryForIos(queryText: newValue)
            }
        )
    }
    
    private func reloadList() {
        assetsVM.setTypeFilterForIos(typeFilter: filterBinding.wrappedValue.toTargetTypeOrNil)
        assetsVM.setSearchQueryForIos(queryText: $searchText.wrappedValue)
    }

    private func delete(_ item: NfcTaggable) {
        assetsVM.deleteItem(id: item.id)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(assetsVM.uiState.assets, id: \.idString) { asset in
                        NavigationLink {
                            AssetDetailView(asset: asset)
                        } label: {
                            AssetRow(asset: asset)
                        }
//                        .id(asset.id)
//                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                            Button(role: .destructive) {
//                                delete(asset)
//                            } label: {
//                                Label("Löschen", systemImage: "trash")
//                            }
//                        }
                    }
                } header: {
                    FilterPicker(filter: filterBinding)
                }
            }
            .modifier(ListStyle())
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddAssetMenu(
                        showAddVehicle: $addVehicle,
                        showAddTool: $addTool,
                        showAddKey: $addKey
                    )
                }
            }
            .refreshable { reloadList() }
        }
        .searchable(text: searchBinding, prompt: "Suchen")
//        .onChange(of: searchText) { _, newValue in
//            assetsVM.setSearchQueryForIos(queryText: newValue)
//        }
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
