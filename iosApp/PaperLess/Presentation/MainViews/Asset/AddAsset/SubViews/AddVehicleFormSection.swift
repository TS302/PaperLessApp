//
//  AddVehicleList.swift
//  PaperLess
//
//  Created by Tom Salih on 24.11.25.
//

import SwiftUI
import Shared

struct AddVehicleFormSection: View {
    
    @Binding var name: String
    @Binding var plate: String
    @Binding var brand: String
    
    let errorMessage: String?
    let isSaving: Bool
    
    var body: some View {
        
        VStack {
            Text("NEUES FAHRZEUG ANLEGEN")
                .font(.system(size: 20))
                .foregroundStyle(Color.primary)
                .fontWeight(.black)
                .padding(.top, 38)
            
            List {
                TextField("Name *", text: $name)
                    .submitLabel(.next)
                
                TextField("Kennzeichen (optional)", text: $plate)
                    .submitLabel(.done)
                
                TextField("Marke (optional)", text: $brand)
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
