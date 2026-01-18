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
    let assetName: String   // <-- NEU: echter Name kommt von außen

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
                    // Nicht von assetName abhängig machen – assign geht über VM.itemId
                    if isReassign {
                        assignAssetVM.reassignToEmployee(employeeId: assetUser.id, note: assignAssetVM.uiState.noteText)
                    } else {
                        assignAssetVM.assignToEmployee(employeeId: assetUser.id, note: assignAssetVM.uiState.noteText)
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


//struct ConfirmAssignDialogSheet: View {
//    @Environment(\.dismiss) private var dismiss
//    
//    @ObservedViewModel var assignAssetVM: AssignAssetViewModel
//    
//    let assetUser: AssetUser
//    
//    @State private var isNoteOn: Bool = false
//    
//    var assetName: String {
//        let name = assignAssetVM.uiState.asset?.name.trimmingCharacters(in: .whitespacesAndNewlines)
//        return (name?.isEmpty == false) ? name! : "Unbenanntes Asset"
//    }
//
//    
//    var body: some View {
//        let isReassign = assignAssetVM.uiState.dialogType == .confirmReassign
//        
//        let fromName: String = {
//            let current = assignAssetVM.uiState.currentAssigneeName
//            if let current, !current.isEmpty {
//                return current
//            } else {
//                return "Firma"
//            }
//        }()
//        
//        let toName = assetUser.name
//        
//        let noteBinding = Binding<String>(
//            get: { assignAssetVM.uiState.noteText },
//            set: { assignAssetVM.setNoteText(value: $0) }
//        )
//        
//        return NavigationStack {
//            VStack {
//                Form {
//                    ConfirmAssignDialogHeaderSection(
//                        isReassign: isReassign,
//                        fromName: fromName,
//                        toName: toName,
//                        assetName: assetName
//                    )
//                    
//                    ConfirmAssignDetailsSection(
//                        assetName: assetName,
//                        fromName: fromName,
//                        toName: toName
//                    )
//                    
//                    Section {
//                        Toggle("Kommentar hinzufügen", isOn: $isNoteOn)
//                        
//                        if isNoteOn {
//                            ConfirmAssignNoteSection(noteText: noteBinding)
//                        }
//                    }
//                }
//                .modifier(ListStyle())
//                .standardToolbar(
//                    leadingAction: { dismiss() },
//                    leadingIcon: "xmark",
//                    leadingIconColor: Color.error,
//                    trailingAction: {
//                        if isReassign {
//                            assignAssetVM.reassignToEmployee(employeeId: assetUser.id, note: assignAssetVM.uiState.noteText)
//                            dismiss()
//                        } else {
//                            assignAssetVM.assignToEmployee(employeeId: assetUser.id, note: assignAssetVM.uiState.noteText)
//                            dismiss()
//                        }
//                    },
//                    trailingIcon: "checkmark"
//                )
//            }
//        }
//        .onAppear {
//            if !assignAssetVM.uiState.noteText.isEmpty {
//                isNoteOn = true
//            }
//        }
//        .onChange(of: isNoteOn) { _, newValue in
//            if newValue == false {
//                assignAssetVM.setNoteText(value: "")
//            }
//        }
//    }
//}
