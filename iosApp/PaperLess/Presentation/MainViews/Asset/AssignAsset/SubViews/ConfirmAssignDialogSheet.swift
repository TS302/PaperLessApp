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
    let employee: Employee
    @State private var isNoteOn: Bool = false
    
    var body: some View {
        let isReassign = assignAssetVM.uiState.dialogType == .confirmReassign
        
        let fromName: String = {
            let current = assignAssetVM.uiState.currentAssigneeName
            if let current, !current.isEmpty {
                return current
            } else {
                return "Firma"
            }
        }()
        
        let toName = employee.name
        
        let noteBinding = Binding<String>(
            get: { assignAssetVM.uiState.noteText },
            set: { assignAssetVM.setNoteText(value: $0) }
        )
        
        return NavigationStack {
            VStack {
                Form {
                    ConfirmAssignDialogHeaderSection(
                        isReassign: isReassign,
                        fromName: fromName,
                        toName: toName,
                        assetName: assignAssetVM.uiState.assetDisplayName ?? "Asset"
                    )
                    
                    ConfirmAssignDetailsSection(
                        assetName: assignAssetVM.uiState.assetDisplayName ?? "Asset",
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "x.circle")
                                    .foregroundStyle(Color.error)
                                    .fontWeight(.bold)
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button {
                                if isReassign {
                                    assignAssetVM.confirmReassign()
                                    dismiss()
                                } else {
                                    assignAssetVM.confirmAssign()
                                    dismiss()
                                }
                            } label: {
                                Text("Bestätigen")
                                    .font(.footnote)
                                    .frame(width: 80, height: 30)
                                    .background(Color.primary)
                                    .foregroundStyle(Color.secondary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if !assignAssetVM.uiState.noteText.isEmpty {
                isNoteOn = true
            }
        }
        .onChange(of: isNoteOn) { _, newValue in
            if newValue == false {
                assignAssetVM.setNoteText(value: "")
            }
        }
    }
}
