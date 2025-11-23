//
//  EditEmployeeSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 19.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct EditEmployeeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var editEmployeeVM = EditEmployeeViewModel()
    
    private var canSave: Bool {
        !editEmployeeVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !editEmployeeVM.uiState.isSaving
    }
    
    var body: some View {
        NavigationStack {
            Form {
                AddEmployeeSections(
                    name: Binding(
                        get: { editEmployeeVM.uiState.name },
                        set: { editEmployeeVM.onNameChange(newName: $0) }
                    ),
                    email: Binding(
                        get: { editEmployeeVM.uiState.email },
                        set: { editEmployeeVM.onEmailChange(newEmail: $0) }
                    ),
                    phoneNumber: Binding(
                        get: { editEmployeeVM.uiState.phoneNumber },
                        set: { editEmployeeVM.onPhoneChange(newPhone: $0) }
                    ),
                    error: editEmployeeVM.uiState.errorMessage
                )
            }
            .modifier(ListStyle())
            .toolbar {
                AddEmployeeToolbar(
                    submit: { editEmployeeVM.save() },
                    canSave: canSave)
            }
            .onChange(of: editEmployeeVM.uiState.isSaving) { _, did in
                if did {
                    dismiss()
                }
            }
        }
    }
}
