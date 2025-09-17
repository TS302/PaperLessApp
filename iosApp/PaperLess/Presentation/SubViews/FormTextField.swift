//
//  FormTextField.swift
//  PaperLess
//
//  Created by Tom Salih on 11.06.25.
//

import SwiftUI

struct FormTextField: View {
    @Binding var value: String
    var label: String
    var icon: String?
    
    var body: some View {
        HStack {
            TextField(label, text: $value)
                .modifier(TextFieldModi())
            Image(systemName: icon ?? "")
            
        }
        .padding(.vertical, 5)
        .foregroundStyle(Color.primary)
        .listRowBackground(Color.secondary)
        
    }
}

#Preview {
    let value = "Test"
    FormTextField(value: .constant(value), label: "TEST")
}
