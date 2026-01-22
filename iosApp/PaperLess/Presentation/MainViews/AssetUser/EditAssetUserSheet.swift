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
    @StateViewModel private var editAssetUserVM = EditAssetUserViewModel()
    
    @State private var didSetup = false
    let assetUser: AssetUser
    
    private var canSave: Bool {
        !editAssetUserVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !editAssetUserVM.uiState.isSaving
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                AddAssetUserForm(
                    name: Binding(
                        get: { editAssetUserVM.uiState.name },
                        set: { editAssetUserVM.onNameChange(newName: $0) }
                    ),
                    email: Binding(
                        get: { editAssetUserVM.uiState.email },
                        set: { editAssetUserVM.onEmailChange(newEmail: $0) }
                    ),
                    phoneNumber: Binding(
                        get: { editAssetUserVM.uiState.phoneNumber },
                        set: { editAssetUserVM.onPhoneChange(newPhone: $0) }
                    ),
                    error: editAssetUserVM.uiState.errorMessage
                )
            }
            .standardToolbar(
                title: assetUser.name,
                leadingAction: { dismiss() },
                leadingIcon: "xmark",
                leadingIconColor: Color.error,
                trailingAction: {
                    editAssetUserVM.save()
                    dismiss()
                },
                trailingIcon: "checkmark"
                
            )
            .background(Color.secondary)
            .onChange(of: editAssetUserVM.uiState.isSaving) { _, did in
                if did {
                    dismiss()
                }
            }
            .onAppear {
                if !didSetup {
                    editAssetUserVM.setEmployee(assetUser: assetUser)
                    didSetup = true
                }
            }
        }
    }
}
