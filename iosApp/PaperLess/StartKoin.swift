//
//  StartKoin.swift
//  PaperLess
//
//  Created by Tom Salih on 08.11.25.
//

import Shared
import FirebaseCore

//MARK: 1
// Hier startet Koin und übergibt die iOS-Services.
func startKoinIos() {
    let authService = IosFirebaseAuthService()
    let assetUserRepository = IosAssetUserRepository()
    let assignmentRepository = IosAssignmentRepository()
    let nfcTaggableRepository = IosNfcTaggableRepository()
    
    KoinIosStarterKt.startKoinIosWithAuth(
        authServiceInstance: authService,
        assetUserRepository: assetUserRepository,
        assignmentRepository: assignmentRepository,
        nfcTaggableRepository: nfcTaggableRepository
    )
}

