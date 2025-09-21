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
    @ObservedViewModel var registrationViewModel: RegistrationViewModel
    
    // Spiegel des KMP-States
    @State private var state = RegistrationUiState(
        firstname: "",
        lastname: "",
        email: "",
        password: "",
        confirmPassword: "",
        success: false,
        errorMessage: nil
    )
    
    // Alert-Zustand (lokal)
    @State private var showErrorAlert = false
    @State private var alertMessage = ""
    
    @State private var showPassword = false
    @State private var uiStateTask: Task<Void, Never>? = nil
    
    private var passwordsMatch: Bool {
        !state.password.isEmpty && state.password == state.confirmPassword
    }
    
    init() {
        let vm = KoinStarter.shared.registrationViewModel()
        self._registrationViewModel = ObservedViewModel(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            // Änderungen gehen ins ViewModel (ohne $)
            let firstnameBinding = Binding<String>(
                get: { state.firstname },
                set: { registrationViewModel.onFirstnameChanged(newFirstname: $0) }
            )
            let lastnameBinding = Binding<String>(
                get: { state.lastname },
                set: { registrationViewModel.onLastnameChanged(newLastname: $0) }
            )
            let emailBinding = Binding<String>(
                get: { state.email },
                set: { registrationViewModel.onEmailChanged(newEmail: $0) }
            )
            let passwordBinding = Binding<String>(
                get: { state.password },
                set: { registrationViewModel.onPasswordChanged(newPassword: $0) }
            )
            let confirmBinding = Binding<String>(
                get: { state.confirmPassword },
                set: { registrationViewModel.onConfirmPasswordChanged(newConfirmPassword: $0) }
            )
            
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
                    .opacity((!passwordsMatch && !state.confirmPassword.isEmpty) ? 1.0 : 0.0)
                
                HStack {
                    Button("Abbrechen") { dismiss() }
                        .font(.footnote)
                        .foregroundStyle(.appPrimary)
                        .opacity(0.8)
                    
                    Spacer()
                    
                    Button("Konto erstellen") {
                        registrationViewModel.register()
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
            .onAppear {
                if uiStateTask == nil {
                    uiStateTask = Task {
                        do {
                            for try await newState in asyncSequence(for: registrationViewModel.uiStateFlow) {
                                if let message = newState.errorMessage, !message.isEmpty {
                                    alertMessage = message
                                    showErrorAlert = true
                                }
                                self.state = newState
                            }
                        } catch {
                            print("uiState stream error:", error)
                        }
                    }
                }
            }
            .onDisappear {
                uiStateTask?.cancel()
                uiStateTask = nil
            }
            .onChange(of: state.success) { _, isSuccess in
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
