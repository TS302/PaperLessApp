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
    @StateViewModel private var employeeDetailVM = EmployeeDetailViewModel()
    
//    init(employeeId: String) {
//        self.employeeId = employeeId
//        _employeeDetailVM = StateViewModel(wrappedValue: KoinStarter.shared.employeesDetailViewModel())
//    }
    
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
                        
                        IconTextFieldRow(
                            systemImageName: "person.fill",
                            placeholder: "Name",
                            text: Binding(
                                get: { employeeDetailVM.uiState.draftName },
                                set: { employeeDetailVM.onNameChange(newName: $0) }
                            ))
                        
                        IconTextFieldRow(systemImageName: "envelope.fill", placeholder: "E-Mail", text: Binding(
                            get: { employeeDetailVM.uiState.draftEmail },
                            set: { employeeDetailVM.onEmailChange(newEmail: $0) }
                        ))
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        
                        IconTextFieldRow(systemImageName: "phone.fill", placeholder: "Telefon", text: Binding(
                            get: { employeeDetailVM.uiState.draftPhone },
                            set: { employeeDetailVM.onPhoneChange(newPhone: $0) }
                        ))
                        .keyboardType(.phonePad)
                        
                    } else {
                        
                        DetailItemStringRow(text: employeeDetailVM.uiState.employee!.name, icon: "person.fill")
                        
                        if !employeeDetailVM.uiState.employee!.email.isEmpty {
                            DetailItemStringRow(text: employeeDetailVM.uiState.employee!.email, icon: "envelope.fill")
                        }
                        if !employeeDetailVM.uiState.employee!.phoneNumber.isEmpty {
                            DetailItemStringRow(text: employeeDetailVM.uiState.employee!.phoneNumber, icon: "phone.fill")
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
                        .foregroundStyle(Color.primary)
                    } else {
                        ForEach(items, id: \.id) { item in
                            HStack(spacing: 12) {
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.primary.opacity(0.2))
                                        Image(systemName: sfSymbol(for: item.type))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(Color.primary)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(item.displayName)
                                            .modifier(ListRowTitle())
                                        
                                        if let code = item.code, !code.isEmpty {
                                            Text(code)
                                                .modifier(ListRowSubtitle())
                                            
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                                
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
        .modifier(ListStyle(title: ""))
//        .navigationTitle("Details")
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

