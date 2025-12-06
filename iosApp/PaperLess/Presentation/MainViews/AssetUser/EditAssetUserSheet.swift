//
//  EditEmployeeSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 19.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct EditAssetUserSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var editEmployeeVM = EditEmployeeViewModel()
    
    @State private var didSetup = false
    let employee: Employee
    
    private var canSave: Bool {
        !editEmployeeVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !editEmployeeVM.uiState.isSaving
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                AddAssetUserForm(
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
                .padding(.top, 32)
                
                SaveAndCancelButtonRow(
                    cancelAction: { dismiss() },
                    saveAction: {
                        editEmployeeVM.save()
                        dismiss()
                    }
                )
            }
            .background(Color.secondary)
            .onChange(of: editEmployeeVM.uiState.isSaving) { _, did in
                if did {
                    dismiss()
                }
            }
            .onAppear {
                if !didSetup {
                    editEmployeeVM.setEmployee(employee: employee)
                    didSetup = true
                }
            }
        }
    }
}
