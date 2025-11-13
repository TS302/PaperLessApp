//
//  RootView.swift
//  PaperLess
//
//  Created by Tom Salih on 01.04.25.
//

import SwiftUI
import Shared
import FirebaseAuth

struct RootView: View {
    @State private var isLoggedIn: Bool = false
    @State private var currentEmail: String = ""

    private let check = CheckUserLoggedInUseCase()

    var body: some View {
        Group {
            if isLoggedIn {
                MainTabView(
                    currentEmail: currentEmail,
                    onLoggedOut: {
                        isLoggedIn = false
                        currentEmail = ""
                    }
                )
            } else {
                LoginView(onLoggedIn: { email in
                    currentEmail = email
                    isLoggedIn = true
                })
            }
        }
        .onAppear {
            isLoggedIn = check.invoke()
            currentEmail = Auth.auth().currentUser?.email ?? ""
        }
    }
}
