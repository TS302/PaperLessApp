package com.tom.paperless

import android.app.Application
import com.google.firebase.FirebaseApp
import com.tom.paperless.di.KoinStarter

class PaperLessAndroidApp : Application() {
    override fun onCreate() {
        super.onCreate()
        KoinStarter.start(this)
        FirebaseApp.initializeApp(this)
    }
}