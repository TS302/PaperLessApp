//
//  StartKoin.swift
//  PaperLess
//
//  Created by Tom Salih on 08.11.25.
//

import Foundation
import Shared 

func startKoinOnIos() {
    let service = IosFirebaseAuthService()
    KoinIosStarterKt.startKoinIosWithAuth(authServiceInstance: service)
}
