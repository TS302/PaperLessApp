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
                Section("Zugewiesene Items") {
                    let items = employeeDetailVM.uiState.assignedItems
                    if items.isEmpty {
                        ContentUnavailableView(
                            "Keine Items zugewiesen",
                            systemImage: "shippingbox",
                            description: Text("Diesem Mitarbeiter sind aktuell keine Assets zugewiesen.")
                        )
                    } else {
                        ForEach(items, id: \.id) { item in
                            HStack(spacing: 12) {
                                Image(systemName: sfSymbol(for: item.type)) // <- hier angepasst
                                    .imageScale(.large)
                                    .frame(width: 28, height: 28)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.displayName)
                                        .font(.body.weight(.semibold))
                                    HStack(spacing: 8) {
                                        if let subtype = item.subtype, !subtype.isEmpty {
                                            Text(subtype).font(.caption).foregroundStyle(.secondary)
                                        }
                                        if let code = item.code, !code.isEmpty {
                                            Text(code).font(.caption).foregroundStyle(.secondary)
                                        }
                                    }
                                }

                                Spacer()

                                if let status = item.statusText, !status.isEmpty {
                                    Text(status)
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.thinMaterial, in: Capsule())
                                }
                            }
                            .contentShape(Rectangle())
                        }
                    }
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

private func sfSymbol(for type: String?) -> String {
    switch (type ?? "").lowercased() {
    case "vehicle": return "car.fill"
    case "tool":    return "wrench.fill"
    case "key":     return "key.fill"
    default:        return "shippingbox.fill"
    }
}

