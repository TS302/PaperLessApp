//
//  EmployeeDetailsSection.swift
//  PaperLess
//
//  Created by Tom Salih on 19.11.25.
//

import SwiftUI
import Shared

struct EmployeeDetailsSection: View {
    let employee: Employee
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .frame(width: 64)
                    .foregroundStyle(Color.primary.opacity(0.2))
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundStyle(Color.primary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(employee.name.isEmpty ? "Unbekannt" : employee.name)
                    .font(.headline)
                
                let email = employee.email
                if !email.isEmpty {
                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Keine E-Mail hinterlegt")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                let phone = employee.phoneNumber
                if !phone.isEmpty {
                    Text(phone)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Keine Telefonnummer hinterlegt")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}


