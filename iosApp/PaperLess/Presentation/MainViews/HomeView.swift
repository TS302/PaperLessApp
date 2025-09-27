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
    @ObservedViewModel var companyViewModel: CompanyViewModel
    
    @State private var addVehicle = false
    @State private var addTool = false
    @State private var addKey = false
    
    @State private var uiState = NfcTaggablesUiState.empty()
    @State private var uiStateTask: Task<Void, Never>? = nil
    
    init() {
        let vm = KoinStarter.shared.companyViewModel()
        self._companyViewModel = ObservedViewModel(wrappedValue: vm)
    }
    
    private var filterBinding: Binding<FilterOption> {
        return Binding(
            get: {
                if let filter = uiState.activeTypeFilter {
                    return filter.asFilterOption
                } else { return .all }
            },
            set: { newValue in
                companyViewModel.setTypeFilterForIos(typeFilter: newValue.toTargetTypeOrNil)
            }
        )
    }
    
    private var searchBinding: Binding<String> {
        return Binding(
            get: { uiState.searchQueryText },
            set: { companyViewModel.setSearchQueryForIos(queryText: $0) }
        )
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(uiState.items, id: \.id.description) { item in
                        NavigationLink(destination: ItemDetailView()){
                            ItemRow(item: item)
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
        }
        .frame(maxWidth: .infinity)
        .background(Color.secondary)
        .task {
            companyViewModel.loadAllNfcTaggables()
            companyViewModel.setTypeFilterForIos(typeFilter: filterBinding.wrappedValue.toTargetTypeOrNil)
            companyViewModel.setSearchQueryForIos(queryText: searchBinding.wrappedValue)
            
            uiStateTask?.cancel()
            uiStateTask = Task {
                do {
                    for try await newState in asyncSequence(for: companyViewModel.uiStateFlow) {
                        await MainActor.run { self.uiState = newState }
                    }
                } catch {
                    print("uiState flow error:", error)
                }
            }
        }
        .onDisappear {
            uiStateTask?.cancel()
        }
        .searchable(text: searchBinding, prompt: "Suchen")
    }
}

#Preview {
    HomeView()
}
