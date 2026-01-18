package com.tom.paperless.di

import com.tom.paperless.auth.AuthService
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import org.koin.core.Koin

private var koinIosRef: Koin? = null

fun startKoinIosWithAuth(
    authServiceInstance: AuthService,
    assetUserRepository: AssetUserRepository,
    assignmentRepository: AssignmentRepository,
    nfcTaggableRepository: NfcTaggableRepository
) {
    if (koinIosRef == null) {
        koinIosRef = KoinStarterCommon.start(
            platformModules = iosAuthModule(authServiceInstance) +
                        iosDataModule(
                            assetUserRepository,
                            assignmentRepository,
                            nfcTaggableRepository
                        )
        )
    }
}

fun getKoinIos(): Koin =
    koinIosRef ?: error("Koin iOS wurde noch nicht gestartet")

//fun declareIosRepositories(
//    assetRepo: AssetUserRepository,
//    assignmentRepo: AssignmentRepository,
//    nfcRepo: NfcTaggableRepository
//) {
//    val koin = getKoinIos()
//
//    koin.declare(assetRepo, allowOverride = true)
//    koin.declare(assignmentRepo, allowOverride = true)
//    koin.declare(nfcRepo, allowOverride = true)
//}