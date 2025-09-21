//
//  PaperLessApp.swift
//  PaperLess
//
//  Created by Tom Salih on 28.03.25.
//

import SwiftUI
import Shared

@main
struct PaperLessApp: App {

    init() {
        KoinStarter.shared.start()
        print("✅ KoinStarter.start() called")
    }
    
    var body: some Scene {
        
        WindowGroup {
            RootView()
        }
    }
}

