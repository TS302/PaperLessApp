//
//  AddEmployeeToolbar.swift
//  PaperLess
//
//  Created by Tom Salih on 20.11.25.
//

import SwiftUI

struct AddEmployeeToolbar: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    let submit: () -> Void
    let canSave: Bool
    
    var body: some ToolbarContent {
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
                submit()
                dismiss()
            } label: {
                 Text("Speichern")
            }
            .disabled(!canSave)
        }
    }
    
}
