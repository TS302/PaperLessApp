//
//  AddVehicleSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 12.10.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct AddVehicleSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateViewModel private var addVehicleVM: AddVehicleViewModel
    
    init() {
        _addVehicleVM = StateViewModel(wrappedValue: KoinStarter.shared.addVehicleViewModel())
    }
    
    private enum Field { case name, plate }
    
    private var canSave: Bool {
        let nameOK = !addVehicleVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return nameOK && !addVehicleVM.uiState.isSaving
    }
    
    private var nameBinding: Binding<String> {
        Binding<String>(
            get: { addVehicleVM.uiState.name },
            set: { addVehicleVM.setName(value: $0) }
        )
    }
    
    private var plateBinding: Binding<String> {
        Binding<String>(
            get: { addVehicleVM.uiState.plate },
            set: { addVehicleVM.setPlate(value: $0) }
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name *", text: nameBinding)
                        .submitLabel(.next)

                    TextField("Kennzeichen (optional)", text: plateBinding)
                        .submitLabel(.done)
                } header: {
                    Text("Allgemein")
                }

                if let error = addVehicleVM.uiState.errorMessage, !error.isEmpty {
                    Section("Fehler") {
                        Text(error).foregroundStyle(.red)
                    }
                }

                if addVehicleVM.uiState.isSaving {
                    Section {
                        HStack {
                            ProgressView()
                            Text("Speichere …")
                        }
                    }
                }
            }
            .navigationTitle("Fahrzeug anlegen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") { addVehicleVM.submit() }
                        .disabled(!canSave)
                }
            }
            .onChange(of: addVehicleVM.uiState.didSave) { _, didSave in
                if didSave {
                    addVehicleVM.resetDidSave()
                    dismiss()
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
