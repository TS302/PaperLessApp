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

struct AddEmployeeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var addEmployeeVM = AddEmployeeViewModel()
    
//    init() {
//        _addEmployeeVM = StateViewModel(wrappedValue: KoinStarter.shared.addEmployeeViewModel())
//    }
    
    private var canSave: Bool {
        !addEmployeeVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !addEmployeeVM.uiState.isSaving
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Neuer Mitarbeiter") {
                    TextField("Name *", text: Binding(
                        get: { addEmployeeVM.uiState.name },
                        set: { addEmployeeVM.setName(value: $0) }
                    ))
                    .textInputAutocapitalization(.words)
                    
                    TextField("E-Mail", text: Binding(
                        get: { addEmployeeVM.uiState.email },
                        set: { addEmployeeVM.setEmail(value: $0) }
                    ))
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    
                    TextField("Telefon", text: Binding(
                        get: { addEmployeeVM.uiState.phoneNumber },
                        set: { addEmployeeVM.setPhoneNumber(value: $0) }
                    ))
                    .keyboardType(.phonePad)
                }
                
                if let error = addEmployeeVM.uiState.errorMessage, !error.isEmpty {
                    Section("Fehler") {
                        Text(error).foregroundStyle(.red)
                    }
                }
            }
            
            .modifier(ListStyle(title: ""))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.error)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addEmployeeVM.submit()
                    } label: {
                        if addEmployeeVM.uiState.isSaving { ProgressView() } else { Text("Speichern") }
                    }
                    .disabled(!canSave)
                }
            }
            .onChange(of: addEmployeeVM.uiState.didSave) { _, did in
                if did {
                    dismiss()
                    addEmployeeVM.resetDidSave()
                }
            }
        }
    }
}
