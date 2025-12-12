package com.tom.paperless.di

import org.koin.core.Koin
import org.koin.core.context.startKoin
import org.koin.core.module.Module

object KoinStarterCommon {

    private var koinRef: Koin? = null

    fun start(platformModules: List<Module>): Koin {
        if (koinRef == null) {
            koinRef = startKoin {
                modules(
                    SharedModules.commonModules + platformModules
                )
            }.koin
        }
        return koinRef!!
    }

    fun getKoin(): Koin =
        requireNotNull(koinRef) { "Koin wurde noch nicht gestartet." }
}