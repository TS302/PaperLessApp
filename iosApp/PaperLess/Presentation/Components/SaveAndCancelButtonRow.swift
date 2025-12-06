//
//  SaveAndCancelButtonRow.swift
//  PaperLess
//
//  Created by Tom Salih on 06.12.25.
//

import SwiftUI

struct SaveAndCancelButtonRow: View {
    let cancelAction: () -> Void
    let saveAction: () -> Void
    var body: some View {
        HStack {
            CustomStandardButton(
                action: {
                    cancelAction()
                },
                Label: "Abbrechen",
                color: Color.error
            )
            
            Spacer()
            
            CustomStandardButton(
                action: {
                    saveAction()
                },
                Label: "Speichern",
                color: Color.primary
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
    
}
