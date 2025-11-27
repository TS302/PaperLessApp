//
//  ConfirmAssignNoteSection.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//

import SwiftUI

struct ConfirmAssignNoteSection: View {
    @Binding var noteText: String

    var body: some View {
        Section {
            TextField(
                "Bemerkung zur Übergabe (optional)",
                text: $noteText,
                axis: .vertical
            )
            .lineLimit(3, reservesSpace: true)
        }
    }
}
