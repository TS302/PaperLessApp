//
//  PaperLessApp.swift
//  PaperLess
//
//  Created by Tom Salih on 28.03.25.
//

import SwiftUI
import Shared
import FirebaseCore

@main
struct PaperLessApp: App {

    init() {
        FirebaseApp.configure()
        KoinStarter.shared.start()
        print("✅ KoinStarter.start() called")
    }
    
    var body: some Scene {
        
        WindowGroup {
            RootView()
        }
    }
}

