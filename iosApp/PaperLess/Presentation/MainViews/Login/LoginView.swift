//
//  LoginView.swift
//  PaperLess
//
//  Created by Tom Salih on 28.03.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI


struct LoginView: View {
    
    @ObservedViewModel var loginVM: LoginViewModel

    @State private var showPassword: Bool = false
    @State private var showRegistrationSheet: Bool = false
    
    private var uiState: LoginUiState {
        loginVM.uiState
    }
    
    private var emailBinding: Binding<String> {
        Binding(
            get: { uiState.email },
            set: { loginVM.onEmailChanged(newEmail: $0) }
        )
    }
        
    private var passwordBinding: Binding<String> {
        Binding<String>(
            get: { uiState.password },
            set: { loginVM.onPasswordChanged(newPassword: $0) }
            )
    }

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

            
            TextFieldInput(label: "Benutzername", text: emailBinding)
                .padding(.bottom, 20)
                .autocapitalization(.none)

            SecureTextFieldInput(
                label: "Passwort",
                text: passwordBinding,
                showPassword: $showPassword,
                showEyeIcon: false
            )
            .padding(.bottom, 20)


            HStack {
                Button("Registrieren") {
                    showRegistrationSheet.toggle()
                }
                
                .sheet(isPresented: $showRegistrationSheet) {
                    RegistrationView()
                }
                .font(.footnote)
                .foregroundColor(.appPrimary)
                .opacity(0.8)

                Spacer()

                Button("Anmelden") {
                    loginVM.login()
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
