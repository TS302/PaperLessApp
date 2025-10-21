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
    @EnvironmentObject private var auth: IOSAuthService
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.lodge.fill")
                    Text("Firma")
                }
            
            EmployeesView()
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
