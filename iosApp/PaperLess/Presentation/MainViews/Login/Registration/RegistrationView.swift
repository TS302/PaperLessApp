//
//  RegistrationView.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var showPassword: Bool

    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var showValidationError: Bool = false

    private var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }

    private var formIsValid: Bool {
        isValidEmail(email) &&
        passwordsMatch
    }

    var body: some View {
        VStack {
            Spacer()
            
            Text("REGISTRIEREN")
                .fontWeight(.black)
                .font(.largeTitle)
                .foregroundStyle(Color.primary)
            
            Text("KONTO ANLEGEN UND STARTEN")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
                .opacity(0.8)
                .padding(.bottom, 60)
            
            TextFieldInput(label: "E-mail", text: $email)
                .padding(.bottom, 20)
                .autocapitalization(.none)
            SecureTextFieldInput(
                label: "Passwort",
                text: $password,
                showPassword: $showPassword,
                showEyeIcon: true
            )
            .padding(.bottom, 20)
            .autocapitalization(.none)
            
            SecureTextFieldInput(
                label: "Passwort bestätigen",
                text: $confirmPassword,
                showPassword: $showPassword,
                showEyeIcon: true
            )
            .padding(.bottom, 10)
            .autocapitalization(.none)
            Text("Passwörter stimmen nicht überein.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
                .foregroundStyle(Color.error)
                .padding(.bottom, 6)
                .padding(.horizontal, 40)
                .opacity(!passwordsMatch && !confirmPassword.isEmpty ? 1 : 0)
            
            HStack {
                Button("Abbrechen") {
                    dismiss()
                }
                .font(.footnote)
                .foregroundStyle(.appPrimary)
                .opacity(0.8)

                Spacer()

                Button("Konto erstellen") {
                    if formIsValid {
//                        user.email = email.trimmingCharacters(in: .whitespaces)
//                        user.password = password
//                        user.isLoggedIn = true
//                        dismiss()
                    } else {
                        withAnimation { showValidationError = true }
                    }
                }
                .frame(width: 160, height: 40)
                .background(Color.appPrimary)
                .foregroundStyle(Color.appSecondary)
                .fontWeight(.bold)
                .cornerRadius(6)
                .shadow(color: .gray.opacity(0.6), radius: 4, x: 0, y: 2)
                .disabled(!formIsValid)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appSecondary)
    }

    private func isValidEmail(_ value: String) -> Bool {
        value.contains("@") && value.contains(".") && value.count > 5
    }
}

#Preview {
    RegistrationView(
        showPassword: .constant(false)
    )
}
