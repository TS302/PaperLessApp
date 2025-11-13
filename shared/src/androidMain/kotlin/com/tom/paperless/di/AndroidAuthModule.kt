package com.tom.paperless.di

import com.google.firebase.auth.FirebaseAuth
import com.tom.paperless.auth.AndroidAuthService
import com.tom.paperless.auth.AuthService
import org.koin.dsl.module

val androidAuthModule = module {
    single { FirebaseAuth.getInstance() }
    single<AuthService> { AndroidAuthService(get()) }
}