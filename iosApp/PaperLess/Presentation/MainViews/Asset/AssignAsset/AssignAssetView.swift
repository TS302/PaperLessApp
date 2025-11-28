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
    
    let itemIdString: String
    
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var vm = AssignAssetViewModel()
    
    @State private var searchText: String = ""
    @State private var selectedEmployeeForDialog: Employee?
    @State private var isSearchPresented: Bool = true
    
    @FocusState private var isSearchFocused: Bool
    
    @State private var isNoteOn: Bool = false
    
    private var filteredEmployees: [Employee] {
        let trimmed = searchText.trimmingCharacters(in:.whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return vm.uiState.employees
        }
        let q = trimmed.lowercased()
        return vm.uiState.employees.filter {
            $0.name.lowercased().contains(q)
            || $0.email.lowercased().contains(q)
        }
    }
    
    var body: some View {
        List {
            if !isSearchFocused {
                AssignAssetHeaderSection(assetName: vm.uiState.assetDisplayName)

            }
            
            AssignAssetContentSection(employeeList: filteredEmployees, onEmployeeTap: {
                
            })
            
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
                        vm.onEmployeeTapped(employee: employee)
                        selectedEmployeeForDialog = employee
                    } label: {
                        EmployeeRow(employee: employee)
                    }
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
                Text(vm.uiState.assetDisplayName ?? "")
                    .opacity(0.6)
                    .font(.callout)
                    .fontWeight(.black)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: ""
        )
        .searchFocused($isSearchFocused)
        .onAppear {
            vm.attach(itemIdString: itemIdString)
            isSearchPresented = true
        }
        .onChange(of: vm.uiState.didAssignSuccessfully) { _, success in
            if success {
                dismiss()
                vm.resetSuccessFlag()
            }
        }
        .sheet(item: $selectedEmployeeForDialog) { employee in
//            ConfirmAssignDialogSheet(assignAssetVM: assignAssetVM, employee: employee)
        }
    }
}
