//
//  SecureTextFieldInput.swift
//  PaperLess
//
//  Created by Oguzhan Cirpan on 10.04.25.
//

import SwiftUI

struct SecureTextFieldInput: View {
    
    var label: String
    @Binding var text: String
    @Binding var showPassword: Bool
    var showEyeIcon: Bool = true
    
    var body: some View {
        
        VStack {
            HStack {
                if showPassword {
                    TextField(label, text: $text)
                } else {
                    SecureField(label, text: $text)
                }
                if showEyeIcon {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .padding(.trailing, 10)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.leading, 10)
            .frame(height: 44)
            .background(RoundedRectangle(cornerRadius:6)
            .fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius:6)
            .stroke(Color.primary, lineWidth: 1))
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .background(Color.appSecondary)
    }
}

#Preview {
    SecureTextFieldInput(
        label: "Test-Passwort",
        text: .constant("geheim"),
        showPassword: .constant(false),
        showEyeIcon: true
    )
}
