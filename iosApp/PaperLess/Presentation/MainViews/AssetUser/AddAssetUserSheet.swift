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
    @StateViewModel private var addAssetUserVM = AddAssetUserViewModel()
    
    private var canSave: Bool {
        !addAssetUserVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !addAssetUserVM.uiState.isSaving
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("ASSET-USER HINZUFÜGEN")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.primary)
                    .fontWeight(.black)
                    .padding(.top, 38)
                AddAssetUserForm(
                    name: Binding(
                        get: { addAssetUserVM.uiState.name },
                        set: { addAssetUserVM.setName(value: $0) }
                    ),
                    email: Binding(
                        get: { addAssetUserVM.uiState.email },
                        set: { addAssetUserVM.setEmail(value: $0) }
                    ),
                    phoneNumber: Binding(
                        get: { addAssetUserVM.uiState.phoneNumber },
                        set: { addAssetUserVM.setPhoneNumber(value: $0) }
                    ),
                    error: addAssetUserVM.uiState.errorMessage
                )
                
                SaveAndCancelButtonRow(
                    cancelAction: { dismiss() },
                    saveAction: { addAssetUserVM.submit() }
                )
            }
            .background(Color.secondary)
            
            .onChange(of: addAssetUserVM.uiState.didSave) { _, did in
                if did {
                    dismiss()
                    addAssetUserVM.resetDidSave()
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
