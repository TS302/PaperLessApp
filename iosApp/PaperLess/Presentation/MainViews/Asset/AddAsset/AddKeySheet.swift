//
//  AddKeySheet.swift
//  PaperLess
//
//  Created by Tom Salih on 12.10.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AddKeySheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var addKeyVM = AddKeyViewModel()
    
    private var canSave: Bool {
        let nameOK = !addKeyVM.uiState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return nameOK && !addKeyVM.uiState.isSaving
    }
    
    private var nameBinding: Binding<String> {
        Binding<String>(
            get: { addKeyVM.uiState.name },
            set: { addKeyVM.setName(value: $0) }
        )
    }
    
    private var serialNumberBinding: Binding<String> {
        Binding<String>(
            get: { addKeyVM.uiState.serialNumber },
            set: { addKeyVM.setSerialNumber(value: $0) }
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("NEUEN SCHLÜSSEL ANLEGEN")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.primary)
                    .fontWeight(.black)
                    .padding(.top, 38)
                
                AddKeyFormSection(
                    name: nameBinding,
                    serialNumber: serialNumberBinding,
                    errorMessage: addKeyVM.uiState.errorMessage,
                    isSaving: addKeyVM.uiState.isSaving
                )
                
                HStack(spacing: 12) {
                    
                    CustomStandardButton(
                        action: {
                            dismiss()
                        },
                        Label: "Abbrechen",
                        color: Color.error
                    )
                    
                    CustomStandardButton(
                        action: {
                            addKeyVM.submit()
                        },
                        Label: "Speichern",
                        color: Color.primary
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(Color.secondary)
            .onChange(of: addKeyVM.uiState.didSave) { _, didSave in
                if didSave {
                    addKeyVM.resetDidSave()
                    dismiss()
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    AddKeySheet()
}
