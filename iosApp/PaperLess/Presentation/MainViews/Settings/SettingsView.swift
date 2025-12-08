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
                Section {
                    HStack {
                        RowIcon(icon: "person.crop.circle.fill")
                        VStack(alignment: .leading) {
                            Text(currentEmail.isEmpty ? "Unbekannter Nutzer" : currentEmail)
                                .modifier(TitleModi())
                            Text("angemeldet").font(.caption)
                                .modifier(SubtitleModi())
                        }
                    }
                }
                if let err = errorText, !err.isEmpty {
                    Section { Text(err).foregroundColor(.red).font(.caption) }
                }
            }
            .modifier(ListStyle())
            .standardToolbar(
                title: "Einstellungen",
                trailingAction: { showConfirm = true },
                trailingIcon: "power"
            )
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
