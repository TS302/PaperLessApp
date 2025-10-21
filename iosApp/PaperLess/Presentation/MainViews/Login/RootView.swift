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
    @StateObject private var auth = IOSAuthService()
    
    var body: some View {
        Group {
            if auth.user != nil {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .environmentObject(auth)
    }
    
}
