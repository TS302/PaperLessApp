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
        VStack {
            Text("NEUES WERKZEUG ANLEGEN")
                .font(.system(size: 20))
                .foregroundStyle(Color.primary)
                .fontWeight(.black)
                .padding(.top, 38)
            
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
                        Text("Speichere…")
                    }
                }
            }
            .modifier(ListStyle())
        }
        .background(Color.secondary)
    }
}

