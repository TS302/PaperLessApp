//
//  RootView.swift
//  PaperLess
//
//  Created by Tom Salih on 01.04.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct RootView: View {
    
    @ObservedViewModel var loginViewModel: LoginViewModel
    
    @State private var loginUiState = LoginUiState(
        email: "",
        password: "",
        success: false,
        errorMessage: nil
    )
    
    @State private var uiStateTask: Task<Void, Never>? = nil
    
    init() {
        let loginViewModel = KoinStarter.shared.loginViewModel()
        self._loginViewModel = ObservedViewModel(wrappedValue: loginViewModel)
    }
    
    var body: some View {
        Group {
            if loginUiState.success {
                MainTabView(loginViewModel: loginViewModel)
            } else {
                LoginView(loginViewModel: loginViewModel)
            }
        }
        .onAppear {
            if uiStateTask == nil {
                uiStateTask = Task {
                    do {
                        for try await newState in asyncSequence(for: loginViewModel.uiStateFlow) {
                            self.loginUiState = newState
                        }
                    } catch {
                        print("RootView uiState stream error:", error)
                    }
                }
                loginViewModel.checkIfAlreadyLoggedIn()
            }
        }
        .onDisappear {
            uiStateTask?.cancel()
            uiStateTask = nil
        }
    }
}

