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
    @StateObject private var nfcTagViewModel = CompanyViewModel()
    @ObservedViewModel var loginViewModel: LoginViewModel
    
    
    var body: some View {
        TabView {
            CompanyView()
                .environmentObject(nfcTagViewModel)
                .tabItem {
                    Image(systemName: "house.lodge.fill")
                    Text("Firma")
                }
            
            StaffView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Personal")
                }
            
            SettingsView()
            .tabItem {
                Image(systemName: "gear")
                Text("Einstellungen")
            }
        }
        .tint(.appPrimary)
    }
}
