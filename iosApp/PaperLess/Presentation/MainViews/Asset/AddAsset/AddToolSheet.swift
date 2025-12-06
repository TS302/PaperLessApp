//
//  AddToolSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 12.10.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AddToolSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var addToolVM = AddToolViewModel()
    
    private var canSave: Bool {
        let nameOK = !addToolVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return nameOK && !addToolVM.uiState.isSaving
    }
    
    private var nameBinding: Binding<String> {
        Binding<String>(
            get: { addToolVM.uiState.name },
            set: { addToolVM.setName(value: $0) }
        )
    }
    
    private var serialNumberBinding: Binding<String> {
        Binding<String>(
            get: { addToolVM.uiState.serialNumber },
            set: { addToolVM.setSerialNumber(value: $0) }
        )
    }
    
    private var brandBinding: Binding<String> {
        Binding<String>(
            get: { addToolVM.uiState.brand },
            set: { addToolVM.setBrand(value: $0) }
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                AddToolFormSection(
                    name: nameBinding,
                    serialNumber: serialNumberBinding,
                    brand: brandBinding,
                    errorMessage: addToolVM.uiState.errorMessage,
                    isSaving: addToolVM.uiState.isSaving
                )
                
                SaveAndCancelButtonRow(
                    cancelAction: { dismiss() },
                    saveAction: { addToolVM.submit() }
                )
            }
            .onChange(of: addToolVM.uiState.didSave) { _, didSave in
                if didSave {
                    addToolVM.resetDidSave()
                    dismiss()
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}


#Preview {
    AddToolSheet()
}
