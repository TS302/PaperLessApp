//
//  ConfirmAssignDialog.swift
//  PaperLess
//
//  Created by Tom Salih on 25.11.25.
//

import SwiftUI
import Combine

struct ConfirmAssignDialog: View {
    let assetName: String
    let fromName: String
    let toName: String
    let isReassign: Bool
    
    @Binding var noteText: String
    
    let onConfirm: () -> Void
    let onCancel: () -> Void
    @State private var isNoteOn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    
                    ConfirmAssignHeaderSection(
                        isReassign: isReassign,
                        fromName: fromName,
                        toName: toName
                    )
                    
                    ConfirmAssignDetailsSection(
                        assetName: assetName,
                        fromName: fromName,
                        toName: toName
                    )
                    
                    Section {
                        Toggle("Kommentar hinzufügen", isOn: $isNoteOn)
                    }
                    
                    if isNoteOn {
                        ConfirmAssignNoteSection(noteText: $noteText)
                    }
//                    ConfirmAssignNoteSection(noteText: $noteText)
                }
                .modifier(ListStyle())
                HStack(spacing: 12) {
                    
                    CustomStandardButton(
                        action: {
                            onCancel()
                        },
                        Label: "Abbrechen",
                        color: Color.error
                    )
                                                        
                    CustomStandardButton(
                        action: {
                            onConfirm()
                        },
                        Label: "Speichern",
                        color: Color.primary
                    )
                }
                .padding(.horizontal, 12)
            }
            .onAppear {
                if !noteText.isEmpty {
                    isNoteOn = true
                }
            }
            .onChange(of: isNoteOn) { _, newValue in
                if newValue == false {
                    noteText = ""
                }
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.secondary)
        }
    }
}
