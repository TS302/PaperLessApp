//
//  ConfirmAssignDialog.swift
//  PaperLess
//
//  Created by Tom Salih on 25.11.25.
//

import SwiftUI

struct ConfirmAssignDialog: View {
    let assetName: String
    let fromName: String
    let toName: String
    let isReassign: Bool
    
    @Binding var noteText: String
    
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                // Warnung, falls bereits zugewiesen
                if isReassign {
                    Section {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                            Text("Dieses Asset ist bereits \(fromName) zugewiesen. Es wird nun von \(fromName) zu \(toName) übergeben.")
                                .font(.subheadline)
                        }
                    }
                }
                
                // Von -> An
                Section("Übergabe") {
                    HStack {
                        Text("Von")
                        Spacer()
                        Text(fromName)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("An")
                        Spacer()
                        Text(toName)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Asset")
                        Spacer()
                        Text(assetName)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Kommentar / Bemerkung
                Section("Bemerkung") {
                    TextField(
                        "Bemerkung zur Übergabe (optional)",
                        text: $noteText,
                        axis: .vertical
                    )
                    .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Zuweisung bestätigen")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Bestätigen", action: onConfirm)
                }
            }
        }
    }
}
