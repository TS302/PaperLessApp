//
//  AddEmployeeSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 12.10.25.
//


import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct AddAssetUserSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var addEmployeeVM = AddEmployeeViewModel()
    
    private var canSave: Bool {
        !addEmployeeVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !addEmployeeVM.uiState.isSaving
    }
    
    var body: some View {
        NavigationStack {
            Form {
                AddEmployeeSections(
                    name: Binding(
                        get: { addEmployeeVM.uiState.name },
                        set: { addEmployeeVM.setName(value: $0) }
                    ),
                    email: Binding(
                        get: { addEmployeeVM.uiState.email },
                        set: { addEmployeeVM.setEmail(value: $0) }
                    ),
                    phoneNumber: Binding(
                        get: { addEmployeeVM.uiState.phoneNumber },
                        set: { addEmployeeVM.setPhoneNumber(value: $0) }
                    ),
                    error: addEmployeeVM.uiState.errorMessage
                )
            }
            .modifier(ListStyle())
            .standardToolbar(
                title: "Asset-Nutzer hinzufügen",
                leadingAction: { dismiss() },
                leadingIcon: "xmark.circle",
                leadingIconColor: Color.error,
                trailingAction: { addEmployeeVM.submit() },
                trailingIcon: "checkmark.circle"
            )
//            .toolbar {
//                AddEmployeeToolbar(
//                    submit: { addEmployeeVM.submit() },
//                    canSave: canSave
//                )
//            }
            .onChange(of: addEmployeeVM.uiState.didSave) { _, did in
                if did {
                    dismiss()
                    addEmployeeVM.resetDidSave()
                }
            }
        }
    }
}
