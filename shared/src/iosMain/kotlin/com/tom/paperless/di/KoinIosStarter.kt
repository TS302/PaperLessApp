package com.tom.paperless.di

import com.tom.paperless.auth.AuthService
import org.koin.core.Koin

private var koinIosRef: Koin? = null

fun startKoinIosWithAuth(authServiceInstance: AuthService) {
    if (koinIosRef == null) {
        koinIosRef = KoinStarterCommon.start(
            platformModules = IosPlatformModules.platformModules + iosAuthModule(authServiceInstance)
        )
    }
}

internal fun getKoinIos(): Koin =
    koinIosRef ?: error("Koin iOS wurde noch nicht gestartet")