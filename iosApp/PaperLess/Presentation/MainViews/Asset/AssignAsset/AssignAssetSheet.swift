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
    
    @StateViewModel private var vm = AssignAssetViewModel()
    
    @State private var searchText: String = ""
    
    private var selectedEmployee: Employee? {
        guard let selectedId = vm.uiState.selectedEmployeeId else { return nil }
        return vm.uiState.employees.first {
            String(describing: $0.id) == String(describing: selectedId)
        }
    }
    
    var body: some View {
        NavigationStack {
            AssignAssetContent(
                searchText: $searchText,
                uiState: vm.uiState,
                onClose: onClose,
                onEmployeeTapped: { employee in
                    vm.onEmployeeTapped(employee: employee)
                }
            )
        }
        .onAppear {
            vm.attach(itemIdString: itemIdString)
        }
        // WENN erfolgreich zugewiesen → dieses Sheet schließen
        .onChange(of: vm.uiState.didAssignSuccessfully) { _, ok in
            if ok {
                onClose()
                vm.resetSuccessFlag()
            }
        }
        // EIN Sheet für sowohl Zuweisen als auch Neu-Zuweisen
        .sheet(
            isPresented: Binding(
                get: {
                    vm.uiState.dialogType != nil && selectedEmployee != nil
                },
                set: { newValue in
                    if !newValue {
                        vm.cancelDialog()
                    }
                }
            )
        ) {
            if let employee = selectedEmployee {
                
                // Ist es eine Neu-Zuweisung?
                let isReassign = vm.uiState.dialogType == .confirmReassign
                
                // Von wem kommt das Asset? (Firma oder aktueller Mitarbeiter)
                let fromName: String = {
                    let current = vm.uiState.currentAssigneeName
                    if let current, !current.isEmpty {
                        return current
                    } else {
                        return "Firma"
                    }
                }()
                
                // Zu wem geht es?
                let toName = employee.name
                
                // Binding für den Kommentar
                let noteBinding = Binding<String>(
                    get: { vm.uiState.noteText },
                    set: { vm.setNoteText(value: $0) }
                )
                
                ConfirmAssignDialog(
                    assetName: vm.uiState.assetDisplayName ?? "Asset",
                    fromName: fromName,
                    toName: toName,
                    isReassign: isReassign,
                    noteText: noteBinding,
                    onConfirm: {
                        if isReassign {
                            vm.confirmReassign()
                        } else {
                            vm.confirmAssign()
                        }
                    },
                    onCancel: {
                        vm.cancelDialog()
                    }
                )
            }
        }
    }
}


