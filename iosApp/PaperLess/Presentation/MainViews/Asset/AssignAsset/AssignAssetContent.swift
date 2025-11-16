//
//  AssignAssetContent.swift
//  PaperLess
//
//  Created by Tom Salih on 13.11.25.
//

import SwiftUI
import Shared

struct AssignAssetContent: View {
    
    @Binding var searchText: String
    
    let uiState: AssignAssetUiState
    let onClose: () -> Void
    let onEmployeeTapped: (Employee) -> Void
    
    var body: some View {
        Group {
            if uiState.isLoading {
                ProgressView("Mitarbeiter werden geladen...")
            } else if let error = uiState.errorMessage, !error.isEmpty {
                VStack {
                    Text("Fehler")
                        .font(.headline)
                    Text(error)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else if uiState.employees.isEmpty {
                ContentUnavailableView("Keine Mitarbeiter gefunden", systemImage: "person.2.slash")
            } else {
                EmployeeListView(
                    employees: filteredEmployees,
                    onEmployeeTapped: onEmployeeTapped
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Schließen") {
                    onClose()
                }
            }
        }
        .searchable(text: $searchText, prompt: "Suchen")
    }
    
    private var filteredEmployees: [Employee] {
        guard !searchText.isEmpty else { return uiState.employees }
        let q = searchText.lowercased()
        return uiState.employees.filter {
            $0.name.lowercased().contains(q) || $0.email.lowercased().contains(q)
        }
    }
}
