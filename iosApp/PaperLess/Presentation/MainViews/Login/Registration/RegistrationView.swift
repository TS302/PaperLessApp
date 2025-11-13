//
//  RegistrationView.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI
import Shared
import KMPNativeCoroutinesAsync
import KMPObservableViewModelSwiftUI

struct RegistrationView: View {
    @StateViewModel var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) private var dismiss
    let onRegisteredAndLoggedIn: (String) -> Void
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var showPassword = false
    
    private var emailBinding: Binding<String> {
        Binding<String>(
            get: { viewModel.uiState.email },
            set: { viewModel.onEmailChanged(newValue: $0) }
        )
    }
    
    private var passwordBinding: Binding<String> {
        Binding<String>(
            get: { viewModel.uiState.password },
            set: { viewModel.onPasswordChanged(newValue: $0) }
        )
    }
    
    private var confirmPasswordBinding: Binding<String> {
        Binding<String>(
            get: { viewModel.uiState.confirmPassword },
            set: { viewModel.onConfirmPasswordChanged(newValue: $0) }
        )
    }
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
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
                    text: confirmPasswordBinding,
                    showPassword: $showPassword,
                    showEyeIcon: true
                )
                .padding(.bottom, 20)
                .autocapitalization(.none)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Abbrechen")
                            .font(.footnote)
                            .foregroundStyle(.appPrimary)
                            .opacity(0.8)
                    }
                    
                    Spacer()
                    
                    Button {
                        guard viewModel.uiState.password == viewModel.uiState.confirmPassword else {
                            alertMessage = "Passwörter stimmen nicht überein."
                            showAlert = true
                            return
                        }
                        viewModel.register()
                    } label: {
                        Text("Registrieren")
                            .frame(width: 160, height: 40)
                            .background(Color.appPrimary)
                            .foregroundStyle(Color.appSecondary)
                            .fontWeight(.bold)
                            .cornerRadius(6)
                            .shadow(color: .gray.opacity(0.6), radius: 4, x: 0, y: 2)
                    }
                    .disabled(viewModel.uiState.isLoading)
                }
                .padding(.top, 40)
                .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondary)
            .task(id: viewModel.uiState.success) {
                if viewModel.uiState.success {
                    onRegisteredAndLoggedIn(viewModel.uiState.email)
                    dismiss()
                }
            }
            .task(id: viewModel.uiState.errorMessage) {
                if let msg = viewModel.uiState.errorMessage, !msg.isEmpty {
                    alertMessage = msg
                    showAlert = true
                }
            }
            .alert("Fehler", isPresented: $showAlert) {
                Button("OK") { showAlert = false }
            } message: { Text(alertMessage) }
        }
    }
}

