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
    
    @StateViewModel var loginVM = LoginViewModel()
    
    private var uiState: LoginUiState {
        loginVM.uiState
    }
    
    var body: some View {
        Group {
            if uiState.success {
                MainTabView(loginViewModel: loginVM)
            } else {
                LoginView(loginVM: loginVM)
            }
        }
        .onAppear {
            loginVM.checkIfAlreadyLoggedIn()
        }
    }
}

