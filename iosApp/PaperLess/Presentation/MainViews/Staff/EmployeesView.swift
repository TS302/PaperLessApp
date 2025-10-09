//
//  StaffView.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct EmployeesView: View {
    @ObservedViewModel var employeesVM: EmployeesViewModel
    @State private var uiState = EmployeesUiState.companion.empty()
    
    @State private var task: Task<Void, Never>? = nil
    
    init() {
        _employeesVM = ObservedViewModel(wrappedValue: KoinStarter.shared.employeesViewModel())
    }
    
    private var searchTextBinding: Binding<String> {
        Binding(
            get: { uiState.searchQueryText },
            set: { employeesVM.setSearchQueryForIos(queryText: $0) }
        )
    }
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(uiState.items, id: \.id.description) { employee in
                        NavigationLink {
                            EmployeeDetailView()
                        } label: {
                            EmployeeRow(employee: employee)
                        }
                    }
                } header: {
                    SectionHeader(text: "Mitarbeiter")
                }
            }
            .modifier(ListStyle(title: ""))
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundStyle(Color.primary)
                    }
                }
            }
        }
        .task {
            task?.cancel()
            task = Task {
                do {
                    for try await state in asyncSequence(for: employeesVM.uiStateFlow) {
                        await MainActor.run { uiState = state }
                    }
                } catch {
                    print("employees uiState flow error:", error)
                }
            }
        }
        .onDisappear { task?.cancel() }
        .searchable(text: self.searchTextBinding, prompt: Text("Suchen"))
    }
}

#Preview {
    EmployeesView()
}
