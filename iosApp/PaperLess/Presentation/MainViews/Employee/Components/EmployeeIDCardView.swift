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
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    CustomLabeledContent(label: "Name", content: name)
                        .padding(.bottom, 2)
                    CustomLabeledContent(label: "Telefonnummer", content: phoneNumber)
                   
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.primary.opacity(0.15))
                        .frame(width: 90, height: 110)
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 50))
                        .foregroundColor(.primary)
                }
                .padding(.top, 4)
            }
            CustomLabeledContent(label: "Email", content: email)
        }
        .padding(4)
        
    }
}
