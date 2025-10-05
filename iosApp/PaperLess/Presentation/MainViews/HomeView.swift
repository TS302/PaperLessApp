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
    @ObservedViewModel var companyVM: CompanyViewModel

    @State private var addVehicle = false
    @State private var addTool = false
    @State private var addKey = false

    @State private var uiState = NfcTaggablesUiState.empty()
    @State private var uiStateTask: Task<Void, Never>? = nil

    init() {
        let vm = KoinStarter.shared.companyViewModel()
        self._companyVM = ObservedViewModel(wrappedValue: vm)
    }

    private var filterBinding: Binding<FilterOption> {
        Binding(
            get: {
                if let f = uiState.activeTypeFilter { return f.asFilterOption }
                return .all
            },
            set: { newValue in
                companyVM.setTypeFilterForIos(typeFilter: newValue.toTargetTypeOrNil)
            }
        )
    }

    private var searchBinding: Binding<String> {
        Binding(
            get: { uiState.searchQueryText },
            set: { companyVM.setSearchQueryForIos(queryText: $0) }
        )
    }

    // optional: triggert nur Recompute, kein echtes Reload nötig
    private func reloadList() {
        companyVM.setTypeFilterForIos(typeFilter: filterBinding.wrappedValue.toTargetTypeOrNil)
        companyVM.setSearchQueryForIos(queryText: searchBinding.wrappedValue)
    }

    private func delete(_ item: NfcTaggable) {
        companyVM.deleteItem(id: item.id)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(uiState.items, id: \.id.description) { item in
                        NavigationLink {
                            ItemDetailView(item: item) // kein lokales Patchen mehr
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
            .refreshable { reloadList() } // darf bleiben
        }
        .frame(maxWidth: .infinity)
        .background(Color.secondary)
        .task {
            uiStateTask?.cancel()
            uiStateTask = Task {
                do {
                    for try await newState in asyncSequence(for: companyVM.uiStateFlow) {
                        await MainActor.run { self.uiState = newState }
                    }
                } catch {
                    print("uiState flow error:", error)
                }
            }
        }
        .onDisappear { uiStateTask?.cancel() }
        .searchable(text: searchBinding, prompt: "Suchen")
    }
}

#Preview {
    HomeView()
}
