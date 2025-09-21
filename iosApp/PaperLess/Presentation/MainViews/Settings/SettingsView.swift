//
//  SettingsView.swift
//  PaperLess
//
//  Created by Tom Salih on 29.03.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct SettingsView: View {
    
    let loginViewModel: LoginViewModel

    @ObservedViewModel var settingsViewModel: SettingsViewModel

    @State private var settingsUiState = SettingsUiState(
        logoutSuccess: false,
        errorMessage: nil
    )
    @State private var uiStateTask: Task<Void, Never>? = nil

    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        let vm = KoinStarter.shared.settingsViewModel()
        self._settingsViewModel = ObservedViewModel(wrappedValue: vm)
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Konto")) {
                    Button(role: .destructive) {
                        settingsViewModel.logout()
                        loginViewModel.logout()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                            Text("Abmelden")
                        }
                    }
                }
            }
            .navigationTitle("Einstellungen")
        }
        .onAppear {
            if uiStateTask == nil {
                uiStateTask = Task {
                    do {
                        for try await newState in asyncSequence(for: settingsViewModel.uiStateFlow) {
                            self.settingsUiState = newState
                        }
                    } catch {
                        print("SettingsView uiState stream error:", error)
                    }
                }
            }
        }
        .onDisappear {
            uiStateTask?.cancel()
            uiStateTask = nil
        }
    }
}
