package com.tom.paperless.di

import com.tom.paperless.auth.AuthService
import org.koin.dsl.module

fun iosAuthModule(authService: AuthService) = module {
    single<AuthService> { authService }
}