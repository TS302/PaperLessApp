//
//  EmployeeDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 09.10.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct EmployeeDetailView: View {
    let employeeId: String
    @StateViewModel private var employeeDetailVM: EmployeeDetailViewModel
    
    init(employeeId: String) {
        self.employeeId = employeeId
        _employeeDetailVM = StateViewModel(wrappedValue: KoinStarter.shared.employeesDetailViewModel())
    }
    
    var body: some View {
        Form {
            if employeeDetailVM.uiState.isLoading {
                ProgressView("Lade Mitarbeiter …")
            } else if let error = employeeDetailVM.uiState.errorMessage, !error.isEmpty {
                Section("Fehler") {
                    Text(error).foregroundStyle(.appError)
                }
            } else if employeeDetailVM.uiState.employee != nil {
                Section("Mitarbeiter") {
                    if employeeDetailVM.uiState.isEditing {
                        TextField("Name", text: Binding(
                            get: { employeeDetailVM.uiState.draftName },
                            set: { employeeDetailVM.onNameChange(newName: $0) }
                        ))
                        TextField("E-Mail", text: Binding(
                            get: { employeeDetailVM.uiState.draftEmail },
                            set: { employeeDetailVM.onEmailChange(newEmail: $0) }
                        ))
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        
                        TextField("Telefon", text: Binding(
                            get: { employeeDetailVM.uiState.draftPhone },
                            set: { employeeDetailVM.onPhoneChange(newPhone: $0) }
                        ))
                        .keyboardType(.phonePad)
                    } else {
                        Label(employeeDetailVM.uiState.employee!.name, systemImage: "person").font(.headline)
                        if !employeeDetailVM.uiState.employee!.email.isEmpty {
                            Label(employeeDetailVM.uiState.employee!.email, systemImage: "envelope")
                        }
                        if !employeeDetailVM.uiState.employee!.phoneNumber.isEmpty {
                            Label(employeeDetailVM.uiState.employee!.phoneNumber, systemImage: "phone")
                        }
                    }
                }
                Section("Items") {
                    //Musterdaten - Items die dem Mitarbeiter zugewiesen sind
                    Text("VW Crafter")
                    Text("Kreissäge Master 2001")
                    Text("Eingangsschlüssel Herr Müller")
                    Text("Werkzeugkoffer 7200")
                }
            } else {
                Text("Kein Datensatz gefunden.")
                    .fontWeight(.black)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            employeeDetailVM.load(idString: employeeId)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if employeeDetailVM.uiState.isSaving {
                    ProgressView()
                } else if employeeDetailVM.uiState.isEditing {
                    Button {
                        employeeDetailVM.save()
                    } label: {
                        Text("Speichern")
                    }
                    .disabled(!employeeDetailVM.uiState.isValid || !employeeDetailVM.uiState.hasChanges)
                } else {
                    Button {
                        employeeDetailVM.beginEdit()
                    } label: {
                        Text("Bearbeiten")
                    }
                }
            }
        }
    }
}

