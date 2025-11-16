//
//  AssignAssetDialogs.swift
//  PaperLess
//
//  Created by Tom Salih on 13.11.25.
//

import SwiftUI
import Shared

extension View {
    func assignAssetDialog(
        uiState: AssignAssetUiState,
        selectedEmployee: Employee?,
        confirmAssign: @escaping () -> Void,
        confirmReassign: @escaping () -> Void,
        cancelDialog: @escaping () -> Void
    ) -> some View {
        
        self
            .sheet(
                isPresented: Binding(
                    get: {
                        uiState.dialogType == .confirmAssign && selectedEmployee != nil
                    },
                    set: { newValue in
                        if !newValue {
                            cancelDialog()
                        }
                    }
                )
            ) {
                if let employee = selectedEmployee {
                    ConfirmAssignDialog(
                        assetName: uiState.assetDisplayName ?? "Asset",
                        employeeName: employee.name,
                        onConfirm: {
                            confirmAssign()
                        },
                        onCancel: {
                            cancelDialog()
                        }
                    )
                }
            }
            .alert(
                "Bereits zugewiesen",
                isPresented: Binding(
                    get: {
                        uiState.dialogType == .confirmReassign
                    },
                    set: { newValue in
                        if !newValue {
                            cancelDialog()
                        }
                    }
                )
            ) {
                Button("Auflößen & neu zuweisen", role: .destructive) {
                    confirmAssign()
                }
                Button("Abbrechen", role: .cancel) {
                    cancelDialog()
                }
            } message: {
                let currentName = uiState.currentAssigneeName ?? "Unbekannt"
                Text("Dieses Asset ist bereits \(currentName) zugewiesen. Möchten Sie es auflösen und neu zuweisen?")
            }
    }
}
