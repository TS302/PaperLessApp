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
    
    @StateViewModel private var addVehicleVM = AddVehicleViewModel()
        
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
    
    private var brandBinding: Binding<String> {
        Binding<String>(
            get: { addVehicleVM.uiState.brand },
            set: { addVehicleVM.setBrand(value: $0) }
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                AddVehicleFormSection(
                    name: nameBinding,
                    plate: plateBinding,
                    brand: brandBinding,
                    errorMessage: addVehicleVM.uiState.errorMessage,
                    isSaving: addVehicleVM.uiState.isSaving
                )
                
                SaveAndCancelButtonRow(
                    cancelAction: { dismiss() },
                    saveAction: { addVehicleVM.submit() }
                )
            }
            .onChange(of: addVehicleVM.uiState.didSave) { _, didSave in
                if didSave {
                    addVehicleVM.resetDidSave()
                    dismiss()
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}
