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
    @ObservedViewModel private var assignAssetVM = AssignAssetViewModel()
    let employee: Employee

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

        return ConfirmAssignDialog(
            assetName: assignAssetVM.uiState.assetDisplayName ?? "Asset",
            fromName: fromName,
            toName: toName,
            isReassign: isReassign,
            noteText: noteBinding,
            onConfirm: {
                if isReassign {
                    assignAssetVM.confirmReassign()
                    dismiss()
                } else {
                    assignAssetVM.confirmAssign()
                    dismiss()
                }
            },
            onCancel: {
                assignAssetVM.cancelDialog()
                dismiss()
            }
        )
    }
}
