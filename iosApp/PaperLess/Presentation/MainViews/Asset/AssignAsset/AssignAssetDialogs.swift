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
        noteText: String,
        onNoteChanged: @escaping (String) -> Void,
        confirmAssign: @escaping () -> Void,
        confirmReassign: @escaping () -> Void,
        cancelDialog: @escaping () -> Void
    ) -> some View {
        
        self.sheet(
            isPresented: Binding(
                get: {
                    // Sheet öffnen, wenn ein Dialog aktiv ist
                    // und ein Mitarbeiter ausgewählt wurde
                    uiState.dialogType != nil && selectedEmployee != nil
                },
                set: { newValue in
                    if !newValue {
                        cancelDialog()
                    }
                }
            )
        ) {
            if let employee = selectedEmployee {
                
                // Ist es eine Neu-Zuweisung?
                let isReassign = uiState.dialogType == .confirmReassign
                
                // Von wem kommt das Asset? (Firma oder aktueller Mitarbeiter)
                let fromName: String = {
                    let current = uiState.currentAssigneeName
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
                    get: { noteText },
                    set: { newValue in onNoteChanged(newValue)
                    }
                )
                
                ConfirmAssignDialog(
                    assetName: uiState.assetDisplayName ?? "Asset",
                    fromName: fromName,
                    toName: toName,
                    isReassign: isReassign,
                    noteText: noteBinding,
                    onConfirm: {
                        if isReassign {
                            confirmReassign()
                        } else {
                            confirmAssign()
                        }
                    },
                    onCancel: {
                        cancelDialog()
                    }
                )
            }
        }
    }
}
