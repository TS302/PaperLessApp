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
    @StateViewModel var employeeVM = AssetsViewModel()
    
    @State private var addVehicle = false
    @State private var addTool = false
    @State private var addKey = false
    @State private var searchText: String = ""

    private var filterBinding: Binding<FilterOption> {
        Binding(
            get: {
                if let filter = employeeVM.uiState.activeTypeFilter { return filter.asFilterOption }
                return .all
            },
            set: { newValue in
                employeeVM.setTypeFilterForIos(typeFilter: newValue.toTargetTypeOrNil)
            }
        )
    }

    private var searchBinding: Binding<String> {
        Binding(
            get: { searchText },
            set: { newValue in
                searchText = newValue
                employeeVM.setSearchQueryForIos(queryText: newValue)
            }
        )
    }
    
    private func reloadList() {
        employeeVM.setTypeFilterForIos(typeFilter: filterBinding.wrappedValue.toTargetTypeOrNil)
        employeeVM.setSearchQueryForIos(queryText: $searchText.wrappedValue)
    }

    private func delete(_ item: NfcTaggable) {
        employeeVM.deleteItem(id: item.id)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(employeeVM.uiState.items, id: \.idString) { item in
                        NavigationLink {
                            AssetDetailView(asset: item)
                        } label: {
                            AssetRow(item: item)
                        }
                        .id(item.id)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                delete(item)
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
        .searchable(text: $searchText, prompt: "Suchen")
        .onChange(of: searchText) { _, newValue in
            employeeVM.setSearchQueryForIos(queryText: newValue)
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
