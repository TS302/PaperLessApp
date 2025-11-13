//
//  LoginView.swift
//  PaperLess
//
//  Created by Tom Salih on 28.03.25.
//

import SwiftUI
import Shared
import KMPNativeCoroutinesAsync
import KMPObservableViewModelSwiftUI

struct LoginView: View {
    let onLoggedIn: (String) -> Void
    
    @StateViewModel var loginVM = LoginViewModel()
    
    @State private var showPassword = false
    @State private var showRegistration: Bool = false
    @State private var isBusy: Bool = false
    @State private var errorText: String?
    
    private var emailBinding: Binding<String> {
        Binding<String>(
            get: { loginVM.uiState.email},
            set: { loginVM.onEmailChanged(newEmail: $0)}
        )
    }
    
    private var passwordBinding: Binding<String> {
        Binding<String>(
            get: { loginVM.uiState.password},
            set: { loginVM.onPasswordChanged(newPassword: $0)}
        )
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 60)
                .padding(.bottom, 40)
            
            TextFieldInput(label: "Email", text: emailBinding)
                .padding(.bottom, 20)
                .autocapitalization(.none)
            
            SecureTextFieldInput(label: "Passwort", text: passwordBinding, showPassword: $showPassword)
                .padding(.bottom, 40)
            
            HStack {
                Button {
                    showRegistration.toggle()
                } label: {
                    Text("Registrieren")
                        .font(.footnote)
                        .foregroundStyle(.appPrimary)
                        .opacity(0.8)
                }
                .sheet(isPresented: $showRegistration) {
                    RegistrationView(onRegisteredAndLoggedIn: onLoggedIn)
                }
                Spacer()
                Button {
                    loginVM.login()
                } label: {
                    Text("Anmelden")
                        .frame(width: 160, height: 40)
                        .background(Color.appPrimary)
                        .foregroundStyle(Color.appSecondary)
                        .fontWeight(.bold)
                        .cornerRadius(6)
                        .shadow(color: .gray.opacity(0.6), radius: 4, x: 0, y: 2)
                }
                
            }
//            .padding(.top, 40)
            .padding(.horizontal, 40)
            if let msg = errorText, !msg.isEmpty {
                Text(msg).foregroundColor(.red).font(.caption)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary)
        .task(id: loginVM.uiState) {
            let state = loginVM.uiState
            isBusy = state.isLoading
            errorText = state.errorMessage ?? ""
            if state.success {
                Task { @MainActor in
                    onLoggedIn(state.email)
                }
            }
        }
    }
}
