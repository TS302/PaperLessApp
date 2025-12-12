package com.tom.paperless.di

import android.app.Application
import com.tom.paperless.ui.viewModels.AssetsViewModel
import org.koin.android.ext.koin.androidContext
import org.koin.core.Koin
import org.koin.core.context.GlobalContext.startKoin

object KoinStarter {
    private var koinRef: Koin? = null
    fun start(application: Application) {
        if (koinRef == null) {
            koinRef = startKoin {
                androidContext(application)
                modules(
                    SharedModules.commonModules + AndroidPlatformModules.platformModules
                )
            }.koin
        }
    }

    private fun getKoin(): Koin =
        requireNotNull(koinRef) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start(application) auf." }
    fun companyViewModel(): AssetsViewModel =
        getKoin().get(clazz = AssetsViewModel::class)
}