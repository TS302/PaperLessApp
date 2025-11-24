//
//  AddToolFormSection.swift
//  PaperLess
//
//  Created by Tom Salih on 25.11.25.
//

import SwiftUI

struct AddToolFormSection: View {
    @Binding var name: String
    @Binding var serialNumber: String
    @Binding var brand: String
    
    let errorMessage: String?
    let isSaving: Bool
    
    var body: some View {
        List {
            TextField("Name *", text: $name)
                .submitLabel(.next)
            
            TextField("Marke (optional)", text: $brand)
                .submitLabel(.done)
            
            TextField("Seriennummer (optional)", text: $serialNumber)
                .submitLabel(.done)
            
            if let errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(Color.error)
            }
            
            if isSaving {
                HStack {
                    ProgressView()
                    Text("Speichere …")
                }
            }
        }
        .modifier(ListStyle())
    }
}

