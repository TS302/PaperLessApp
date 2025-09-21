//
//  LoginView.swift
//  PaperLess
//
//  Created by Tom Salih on 28.03.25.
//

import SwiftUI
import Shared

struct LoginView: View {
    
    let loginViewModel: LoginViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showRegistrationSheet: Bool = false

    var body: some View {
        VStack(spacing: 16) {

            Text("PAPERLESS")
                .fontWeight(.black)
                .font(.largeTitle)
                .foregroundStyle(Color.primary)

            Text("DIGITALISIEREN & VERWALTEN!")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
                .opacity(0.8)
                .padding(.bottom, 60)

            
            TextFieldInput(label: "Benutzername", text: $email)
                .padding(.bottom, 20)
                .autocapitalization(.none)
                .onChange(of: email) { _, newValue in
                    loginViewModel.onEmailChanged(newEmail: newValue)
                }

            SecureTextFieldInput(
                label: "Passwort",
                text: $password,
                showPassword: $showPassword,
                showEyeIcon: false
            )
            .padding(.bottom, 20)
            .onChange(of: password) { _, newValue in
                loginViewModel.onPasswordChanged(newPassword: newValue)
            }

            HStack {
                Button("Registrieren") {
                    showRegistrationSheet.toggle()
                    email = ""
                    password = ""
                }
                .sheet(isPresented: $showRegistrationSheet) {
                    RegistrationView()
                }
                .font(.footnote)
                .foregroundColor(.appPrimary)
                .opacity(0.8)

                Spacer()

                Button("Anmelden") {
                    loginViewModel.login()
                }
                .frame(width: 160, height: 40)
                .background(Color.appPrimary)
                .foregroundStyle(Color.appSecondary)
                .fontWeight(.bold)
                .cornerRadius(6)
                .shadow(color: .gray.opacity(0.6), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary)
    }
}
