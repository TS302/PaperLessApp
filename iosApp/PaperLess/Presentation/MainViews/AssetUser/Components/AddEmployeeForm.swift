//
//  AddEmployeeForm.swift
//  PaperLess
//
//  Created by Tom Salih on 20.11.25.
//

import SwiftUI

struct AddEmployeeSections: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var phoneNumber: String
    let error: String?

    var body: some View {
        Section {
            TextField("Name *", text: $name)
                .textInputAutocapitalization(.words)

            TextField("E-Mail", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

            TextField("Telefon", text: $phoneNumber)
                .keyboardType(.phonePad)
        }

        if let error, !error.isEmpty {
            Section("Fehler") {
                Text(error)
                    .foregroundStyle(.red)
            }
        }
    }
}
