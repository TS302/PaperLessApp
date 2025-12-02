//
//  AssignAssetView.swift
//  PaperLess
//
//  Created by Tom Salih on 27.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AssignAssetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var assignAssetVM = AssignAssetViewModel()
    
    let itemIdString: String
    @State private var searchText: String = ""
    @State private var selectedEmployeeForDialog: Employee?
    @FocusState private var isSearchFocused: Bool
    
    private var filteredEmployees: [Employee] {
        let trimmed = searchText.trimmingCharacters(in:.whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return assignAssetVM.uiState.employees
        }
        let q = trimmed.lowercased()
        return assignAssetVM.uiState.employees.filter {
            $0.name.lowercased().contains(q)
            || $0.email.lowercased().contains(q)
        }
    }
    
    var body: some View {
        List {
            Section {
                if !isSearchFocused {
                    AssignAssetHeaderSection(assetName: assignAssetVM.uiState.assetDisplayName)
                }
            }
            
            Section {
                AssignAssetEmployeeListSection(
                    employeeList: filteredEmployees
                ) { employee in
                    assignAssetVM.onEmployeeTapped(employee: employee)
                    selectedEmployeeForDialog = employee
                }
            }
        }
        .modifier(ListStyle())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left.circle")
                            .fontWeight(.bold)
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(assignAssetVM.uiState.assetDisplayName ?? "")
                    .opacity(0.6)
                    .font(.callout)
                    .fontWeight(.black)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .searchable(text: $searchText, prompt: "Suchen")
        .searchFocused($isSearchFocused)
        .onAppear {
            assignAssetVM.attach(itemIdString: itemIdString)
        }
        .onChange(of: assignAssetVM.uiState.didAssignSuccessfully) { _, success in
            if success {
                dismiss()
                assignAssetVM.resetSuccessFlag()
            }
        }
        .sheet(item: $selectedEmployeeForDialog) { employee in
            ConfirmAssignDialogSheet(assignAssetVM: assignAssetVM, employee: employee)
        }
    }
}
