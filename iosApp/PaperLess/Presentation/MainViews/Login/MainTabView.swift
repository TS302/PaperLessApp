//
//  TabView.swift
//  PaperLess
//
//  Created by Tom Salih on 29.03.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct MainTabView: View {
    
    let currentEmail: String
    let onLoggedOut: () -> Void
    
    var body: some View {
        TabView {
            AssetsView()
                .tabItem {
                    Image(systemName: "backpack.sensor.tag.radiowaves.left.and.right.fill")
                    Text("Assets")
                }
            
            EmployeesView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Asset-Nutzer")
                }
            
            SettingsView(currentEmail: currentEmail, onLoggedOut: onLoggedOut)
            .tabItem {
                Image(systemName: "gear")
                Text("Einstellungen")
            }
        }
        .tint(.primary)
    }
}
