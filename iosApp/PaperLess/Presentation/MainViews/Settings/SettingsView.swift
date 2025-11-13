//
//  SettingsView.swift
//  PaperLess
//
//  Created by Tom Salih on 29.03.25.
//

import SwiftUI
import Shared
import KMPNativeCoroutinesAsync
import KMPObservableViewModelSwiftUI

struct SettingsView: View {
    @StateViewModel var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let currentEmail: String
    let onLoggedOut: () -> Void
    
    @State private var isBusy = false
    @State private var showConfirm = false
    @State private var errorText: String?
   

    var body: some View {
        NavigationStack {
            List {
                Section("Konto") {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                        VStack(alignment: .leading) {
                            Text(currentEmail.isEmpty ? "Unbekannter Nutzer" : currentEmail)
                                .font(.subheadline)
                            Text("angemeldet").font(.caption)
                        }
                    }
                    Button("Abmelden", role: .destructive) { showConfirm = true
                    }
                }
                if let err = errorText, !err.isEmpty {
                    Section { Text(err).foregroundColor(.red).font(.caption) }
                }
            }
            .navigationTitle("Einstellungen")
        }
        .confirmationDialog("Wirklich abmelden?", isPresented: $showConfirm, titleVisibility: .visible) {
            Button("Abmelden", role: .destructive) {
                viewModel.logout()
            }
            Button("Abbrechen", role: .cancel) {
                dismiss()
            }
        }
        .task(id: viewModel.uiState) {
            let state = viewModel.uiState
            isBusy = state.isLoading
            errorText = state.errorMessage
            if state.logoutSuccess {
                Task { @MainActor in
                    onLoggedOut()
                }
            }
        }
    }
}

//import SwiftUI
//import Shared
//import KMPObservableViewModelSwiftUI
//import KMPNativeCoroutinesAsync
//
//struct SettingsView: View {
//    @EnvironmentObject private var auth: IOSAuthService
//    @State private var showLogoutConfirm = false
//
//    var body: some View {
//        NavigationStack {
//            List {
//                Section(header: Text("Konto")) {
//                    HStack {
//                        Image(systemName: "person.crop.fill")
//                        VStack(alignment: .leading) {
//                            Text(auth.user?.email ?? "Unbekannter Nutzer")
//                                .font(.subheadline)
//                                .foregroundStyle(Color.primary)
//                            Text("angemeldet")
//                                .font(.caption)
//                                .foregroundStyle(Color.primary)
//                        }
//                    }
//                    
//                    Button(role: .destructive) {
//                        showLogoutConfirm = true
//                    } label: {
//                        HStack {
//                            Image(systemName: "power.circle.fill")
//                                .foregroundStyle(Color.error)
//                            Text("Abmelden")
//                                .font(.subheadline)
//                                .foregroundStyle(Color.primary)
//                        }
//                    }
//                }
//            }
//            .modifier(ListStyle(title: "Einstellungen"))
//        }
//        .confirmationDialog(
//            "Wirklich abmelden?",
//            isPresented: $showLogoutConfirm,
//            titleVisibility: .visible
//        ) {
//            Button("Abmelden", role: .destructive) {
//                auth.signOut()
//            }
//            
//            Button("Abbrechen", role: .cancel) { }
//        }
//    }
//}
