//
//  EmployeeIDCardView.swift
//  PaperLess
//
//  Created by Tom Salih on 24.11.25.
//

import SwiftUI

struct EmployeeIDCardView: View {
    let name: String
    let phoneNumber: String
    let email: String
    let id: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
                
                HStack(spacing: 14) {
                    RowIcon(icon: "person.and.background.dotted")
                    CustomLabeledContent(label: "Name", content: name)
                }
                
                HStack(spacing: 14) {
                    RowIcon(icon: "phone.fill")
                    CustomLabeledContent(label: "Telefonnummer", content: phoneNumber)
                }
                
                HStack(spacing: 14) {
                    RowIcon(icon: "envelope.fill")
                    CustomLabeledContent(label: "Email", content: email)
                }
        }
    }
}
