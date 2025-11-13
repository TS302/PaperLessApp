package com.tom.paperless.di

import com.tom.paperless.auth.AuthService
import org.koin.core.Koin
import org.koin.core.context.startKoin

private var koinIosRef: Koin? = null

fun startKoinIosWithAuth(authServiceInstance: AuthService) {
    if (koinIosRef == null) {
        koinIosRef = startKoin {
            modules(
                appModule,
                iosAuthModule(authServiceInstance)
            )
        }.koin
    }
}

internal fun getKoinIos(): Koin =
    koinIosRef ?: error("Koin iOS wurde noch nicht gestartet")
