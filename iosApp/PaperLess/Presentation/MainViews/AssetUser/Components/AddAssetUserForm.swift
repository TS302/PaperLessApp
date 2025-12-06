//
//  AddAssetUserForm.swift
//  PaperLess
//
//  Created by Tom Salih on 20.11.25.
//

import SwiftUI

struct AddAssetUserForm: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var phoneNumber: String
    let error: String?
    
    var body: some View {
        
        List {
            TextField("Name*", text: $name)
                .textInputAutocapitalization(.words)
                .padding(.vertical, 4)
            
            TextField("E-Mail", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding(.vertical, 4)

            
            TextField("Telefon", text: $phoneNumber)
                .keyboardType(.phonePad)
                .padding(.vertical, 4)

            
            if let error, !error.isEmpty {
                Text(error)
                    .foregroundStyle(.appError)
                    .padding(.vertical, 4)
            }
        }
        .modifier(ListStyle())
    }
}
