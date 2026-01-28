//
//  ConfirmAssignDialogSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI


struct ConfirmAssignDialogSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedViewModel var assignAssetVM: AssignAssetViewModel
    
    let assetUser: AssetUser
    let assetId: String
    let assetName: String
    
    @State private var isNoteOn: Bool = false
    @State private var didRequestLoad = false
    
    private var isReassign: Bool {
        assignAssetVM.uiState.dialogType == .confirmReassign
    }
    
    private var fromName: String {
        let current = assignAssetVM.uiState.currentAssigneeName
        if let current, !current.isEmpty { return current }
        return "Firma"
    }
    
    private var toName: String { assetUser.name }
    
    private var noteBinding: Binding<String> {
        Binding(
            get: { assignAssetVM.uiState.noteText },
            set: { assignAssetVM.setNoteText(value: $0) }
        )
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if assignAssetVM.uiState.isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Daten werden geladen …")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Form {
                        ConfirmAssignDialogHeaderSection(
                            isReassign: isReassign,
                            fromName: fromName,
                            toName: toName,
                            assetName: assetName
                        )
                        
                        ConfirmAssignDetailsSection(
                            assetName: assetName,
                            fromName: fromName,
                            toName: toName
                        )
                        
                        Section {
                            Toggle("Kommentar hinzufügen", isOn: $isNoteOn)
                            
                            if isNoteOn {
                                ConfirmAssignNoteSection(noteText: noteBinding)
                            }
                        }
                    }
                    .modifier(ListStyle())
                }
            }
            .standardToolbar(
                leadingAction: { dismiss() },
                leadingIcon: "xmark",
                leadingIconColor: Color.error,
                trailingAction: {
                    let trimmed = assignAssetVM.uiState.noteText
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let noteOrNil: String? = (isNoteOn && !trimmed.isEmpty) ? trimmed : nil
                    
                    if isReassign {
                        assignAssetVM.reassignToEmployee(
                            employeeId: assetUser.idString,
                            untilNote: noteOrNil,
                            fromNote: noteOrNil
                        )
                    } else {
                        assignAssetVM.assignToEmployee(
                            employeeId: assetUser.idString,
                            fromNote: noteOrNil
                        )
                    }
                    dismiss()
                },
                trailingIcon: "checkmark"
            )
        }
        .onAppear {
            if !didRequestLoad {
                didRequestLoad = true
                assignAssetVM.attach(assetIdString: assetId)
            }
            if !assignAssetVM.uiState.noteText.isEmpty {
                isNoteOn = true
            }
        }
        .onChange(of: isNoteOn) { _, newValue in
            if newValue == false { assignAssetVM.setNoteText(value: "") }
        }
    }
}
