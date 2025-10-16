//
//  HomeView.swift
//  PaperLess
//
//  Created by Tom Salih on 22.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync



struct HomeView: View {
    @StateViewModel var companyVM: CompanyViewModel = KoinStarter.shared.companyViewModel()
    
    @State private var addVehicle = false
    @State private var addTool = false
    @State private var addKey = false
    @State private var searchText: String = ""

    private var filterBinding: Binding<FilterOption> {
        Binding(
            get: {
                if let f = companyVM.uiState.activeTypeFilter { return f.asFilterOption }
                return .all
            },
            set: { newValue in
                companyVM.setTypeFilterForIos(typeFilter: newValue.toTargetTypeOrNil)
            }
        )
    }

    private var searchBinding: Binding<String> {
        Binding(
            get: { searchText },
            set: { newValue in
                searchText = newValue
                companyVM.setSearchQueryForIos(queryText: newValue)
            }
        )
    }
    
    private func reloadList() {
        companyVM.setTypeFilterForIos(typeFilter: filterBinding.wrappedValue.toTargetTypeOrNil)
        companyVM.setSearchQueryForIos(queryText: $searchText.wrappedValue)
    }

    private func delete(_ item: NfcTaggable) {
        companyVM.deleteItem(id: item.id)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(companyVM.uiState.items, id: \.idString) { item in
                        NavigationLink {
                            ItemDetailView(item: item)
                        } label: {
                            ItemRow(item: item)
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
            .modifier(ListStyle(title: ""))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddObjectMenu(
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
            companyVM.setSearchQueryForIos(queryText: newValue)
        }
        .sheet(isPresented: $addVehicle) {
            AddVehicleSheet()
//                .presentationDetents([.medium])
        }
        .sheet(isPresented: $addTool) {
            AddToolSheet()
//                .presentationDetents([.medium])
        }
        .sheet(isPresented: $addKey) {
            AddKeySheet()
//                .presentationDetents([.medium])
        }
    }
}

#Preview {
    HomeView()
}
