//
//  AssignAssetView.swift
//  PaperLess
//
//  Created by Tom Salih on 27.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI


import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AssignAssetView: View {
    
    let itemIdString: String
    
    @StateViewModel private var vm = AssignAssetViewModel()
    @State private var searchText: String = ""
    @State private var isConfirmSheetPresented: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    // Gefilterte Mitarbeiter für die Suche
    private var filteredEmployees: [Employee] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return vm.uiState.employees
        }
        let q = trimmed.lowercased()
        return vm.uiState.employees.filter {
            $0.name.lowercased().contains(q)
            || $0.email.lowercased().contains(q)
        }
    }
    
    // aktuell im ViewModel ausgewählter Mitarbeiter (für das Sheet)
    private var selectedEmployee: Employee? {
        guard let selectedId = vm.uiState.selectedEmployeeId else { return nil }
        return vm.uiState.employees.first { $0.id == selectedId }
    }
    
    var body: some View {
        List {
            if vm.uiState.isLoading {
                ProgressView("Mitarbeiter werden geladen...")
            } else if let error = vm.uiState.errorMessage, !error.isEmpty {
                VStack {
                    Text("Fehler")
                        .font(.headline)
                    Text(error)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else if filteredEmployees.isEmpty {
                ContentUnavailableView(
                    "Keine Mitarbeiter gefunden",
                    systemImage: "person.2.slash"
                )
            } else {
                ForEach(filteredEmployees, id: \.id) { employee in
                    Button {
                        // Mitarbeiter im VM setzen
                        vm.onEmployeeTapped(employee: employee)
                        // Sheet öffnen
                        isConfirmSheetPresented = true
                    } label: {
                        EmployeeRow(employee: employee)
                    }
                }
            }
        }
        .modifier(ListStyle(title: "Mitarbeiter auswählen"))
        .searchable(text: $searchText, prompt: "Suchen")
        .onAppear {
            vm.attach(itemIdString: itemIdString)
        }
        // Wenn Zuweisung erfolgreich → zurück zur Detail-View
        .onChange(of: vm.uiState.didAssignSuccessfully) { _, success in
            if success {
                dismiss()
                vm.resetSuccessFlag()
            }
        }
        // Sheet mit dem bestehenden Confirm-Dialog
        .sheet(isPresented: $isConfirmSheetPresented) {
            if let employee = selectedEmployee {
                ConfirmAssignDialogSheet(vm: vm, employee: employee)
            }
        }
    }
}
