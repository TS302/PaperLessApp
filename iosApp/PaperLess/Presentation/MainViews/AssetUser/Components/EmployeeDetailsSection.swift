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
        
        
        let name = employee.name
        CustomLabeledContent(label: "Name", content: name)
        
        let phone = employee.phoneNumber
        if !phone.isEmpty {
            CustomLabeledContent(label: "Telefonnummer", content: phone)
        } else {
            Text("Keine Telefonnummer hinterlegt")
                .modifier(SubtitleModi())
        }
        
        let email = employee.email
        if !email.isEmpty {
            CustomLabeledContent(label: "Email", content: email)
        } else {
            Text("Keine E-Mail hinterlegt")
                .modifier(SubtitleModi())
        }
    }
}


