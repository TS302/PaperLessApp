//
//  RootView.swift
//  PaperLess
//
//  Created by Tom Salih on 01.04.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct RootView: View {
    @ObservedViewModel var loginViewModel = LoginViewModel()
    
    var body: some View {
        if loginViewModel.isLoggedIn {
            MainTabView(loginViewModel: loginViewModel)
        } else {
            LoginView(loginViewModel: loginViewModel)
        }
    }
}

#Preview {
    RootView()
}
