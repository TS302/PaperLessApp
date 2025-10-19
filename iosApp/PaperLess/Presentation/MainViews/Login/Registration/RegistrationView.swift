//
//  RegistrationView.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateViewModel var registrationVM = RegistrationViewModel()
    
    @State private var showErrorAlert = false
    @State private var alertMessage = ""
    @State private var showPassword = false
    
    private var uiState: RegistrationUiState {
        registrationVM.uiState
    }
    
    private var passwordsMatch: Bool {
        !uiState.password.isEmpty && uiState.password == uiState.confirmPassword
    }
    
    private var firstnameBinding: Binding<String> {
        Binding<String>(
            get: { uiState.firstname },
            set: { registrationVM.onFirstnameChanged(newFirstname: $0) }
        )
    }
    
    private var lastnameBinding: Binding<String> {
        Binding<String>(
            get: { uiState.lastname },
            set: { registrationVM.onLastnameChanged(newLastname: $0) }
        )
    }
    
    private var emailBinding: Binding<String> {
        Binding<String>(
            get: { uiState.email },
            set: { registrationVM.onEmailChanged(newEmail: $0) }
        )
    }
    
    private var passwordBinding: Binding<String> {
        Binding<String>(
            get: { uiState.password },
            set: { registrationVM.onPasswordChanged(newPassword: $0) }
        )
    }
    
    private var confirmBinding: Binding<String> {
        Binding<String>(
            get: { uiState.confirmPassword },
            set: { registrationVM.onConfirmPasswordChanged(newConfirmPassword: $0) }
        )
    }
    
    
    var body: some View {
        VStack {
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
                
                TextFieldInput(label: "Vorname", text: firstnameBinding)
                    .padding(.bottom, 20)
                    .autocapitalization(.none)
                
                TextFieldInput(label: "Nachname", text: lastnameBinding)
                    .padding(.bottom, 20)
                    .autocapitalization(.none)
                
                TextFieldInput(label: "E-mail", text: emailBinding)
                    .padding(.bottom, 20)
                    .autocapitalization(.none)
                
                SecureTextFieldInput(
                    label: "Passwort",
                    text: passwordBinding,
                    showPassword: $showPassword,
                    showEyeIcon: true
                )
                .padding(.bottom, 20)
                .autocapitalization(.none)
                
                SecureTextFieldInput(
                    label: "Passwort bestätigen",
                    text: confirmBinding,
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
                    .opacity((!passwordsMatch && !uiState.confirmPassword.isEmpty) ? 1.0 : 0.0)
                
                HStack {
                    Button("Abbrechen") { dismiss() }
                        .font(.footnote)
                        .foregroundStyle(.appPrimary)
                        .opacity(0.8)
                    
                    Spacer()
                    
                    Button("Konto erstellen") {
                        registrationVM.register()
                    }
                    .frame(width: 160, height: 40)
                    .background(Color.appPrimary)
                    .foregroundStyle(Color.appSecondary)
                    .fontWeight(.bold)
                    .cornerRadius(6)
                    .shadow(color: .gray.opacity(0.6), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .onChange(of: uiState.errorMessage) { _, message in
                if let message = message, !message.isEmpty {
                    alertMessage = message
                    showErrorAlert = true
                }
                
            }
            .onChange(of: uiState.success) { _, isSuccess in
                if isSuccess { dismiss() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appSecondary)
        .alert("Fehler bei der Registrierung", isPresented: $showErrorAlert) {
            Button("OK") { showErrorAlert = false }
        } message: {
            Text(alertMessage)
        }
    }
}
