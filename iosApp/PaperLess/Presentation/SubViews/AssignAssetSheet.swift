//
//  AssignAssetSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 11.10.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AssignAssetSheet: View {
    let itemIdString: String
    let onClose: () -> Void
    let onAssigned: () -> Void
    
    @StateViewModel private var vm: AssignAssetViewModel
    @State private var searchText: String = ""

    init(itemIdString: String, onClose: @escaping () -> Void, onAssigned: @escaping () -> Void) {
        self.itemIdString = itemIdString
        self.onClose = onClose
        self.onAssigned = onAssigned

        _vm = StateViewModel(
            wrappedValue: KoinStarter.shared.assignAssetViewModel(itemIdString: itemIdString)
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if vm.uiState.isLoading {
                    ProgressView("Mitarbeiter werden geladen …")
                        .padding()
                } else if let error = vm.uiState.errorMessage, !error.isEmpty {
                    VStack(spacing: 12) {
                        Text("Fehler").font(.headline)
                        Text(error).foregroundStyle(.red)
                        Button("Erneut versuchen") { vm.loadEmployees() }
                    }
                    .padding()
                } else {
                    List(filteredEmployees, id: \.id) { employee in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(employee.name).font(.headline)
                                Text(employee.email).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            if vm.uiState.selectedEmployeeId == employee.id {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { vm.selectEmployee(employeeId: employee.id) }
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchText)
                }
            }
            .navigationTitle("Mitarbeiter wählen")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { onClose() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Zuweisen") {
                        vm.assignSelectedEmployee()
                    }
                    .disabled(vm.uiState.selectedEmployeeId == nil || vm.uiState.isLoading)
                }
            }
            .onChange(of: vm.uiState.didAssignSuccessfully) { oldValue, newValue in
                if newValue {
                    vm.resetSuccessFlag()
                    onAssigned()
                    onClose()
                }
            }
        }
    }

    private var filteredEmployees: [Employee] {
        let employees = vm.uiState.employees
        guard !searchText.isEmpty else { return employees }
        let q = searchText.lowercased()
        return employees.filter {
            $0.name.lowercased().contains(q) || $0.email.lowercased().contains(q)
        }
    }
}
