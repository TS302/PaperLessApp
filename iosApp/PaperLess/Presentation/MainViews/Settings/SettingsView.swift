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
    @EnvironmentObject private var auth: IOSAuthService
    @State private var showLogoutConfirm = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Konto")) {
                    HStack {
                        Image(systemName: "person.crop.fill")
                        VStack(alignment: .leading) {
                            Text(auth.user?.email ?? "Unbekannter Nutzer")
                                .font(.subheadline)
                                .foregroundStyle(Color.primary)
                            Text("angemeldet")
                                .font(.caption)
                                .foregroundStyle(Color.primary)
                        }
                    }
                    
                    Button(role: .destructive) {
                        showLogoutConfirm = true
                    } label: {
                        HStack {
                            Image(systemName: "power.circle.fill")
                                .foregroundStyle(Color.error)
                            Text("Abmelden")
                                .font(.subheadline)
                                .foregroundStyle(Color.primary)
                        }
                    }
                }
            }
            .modifier(ListStyle(title: "Einstellungen"))
        }
        .confirmationDialog(
            "Wirklich abmelden?",
            isPresented: $showLogoutConfirm,
            titleVisibility: .visible
        ) {
            Button("Abmelden", role: .destructive) {
                auth.signOut()
            }
            
            Button("Abbrechen", role: .cancel) { }
        }
    }
}
