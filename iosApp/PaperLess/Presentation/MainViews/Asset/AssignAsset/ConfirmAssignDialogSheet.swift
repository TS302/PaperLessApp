//
//  ConfirmAssignDialogSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//

import SwiftUI
import Shared

struct ConfirmAssignDialogSheet: View {
    let vm: AssignAssetViewModel
    let employee: Employee

    var body: some View {
        let isReassign = vm.uiState.dialogType == .confirmReassign

        let fromName: String = {
            let current = vm.uiState.currentAssigneeName
            if let current, !current.isEmpty {
                return current
            } else {
                return "Firma"
            }
        }()

        let toName = employee.name

        let noteBinding = Binding<String>(
            get: { vm.uiState.noteText },
            set: { vm.setNoteText(value: $0) }
        )

        return ConfirmAssignDialog(
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
