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
                    .modifier(ListRowTitle())
                
                let email = employee.email
                if !email.isEmpty {
                    Text(email)
                        .modifier(ListRowSubtitle())
                } else {
                    Text("Keine E-Mail hinterlegt")
                        .modifier(ListRowSubtitle())
                }
                
                let phone = employee.phoneNumber
                if !phone.isEmpty {
                    Text(phone)
                        .modifier(ListRowSubtitle())
                } else {
                    Text("Keine Telefonnummer hinterlegt")
                        .modifier(ListRowSubtitle())
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}


