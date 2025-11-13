package com.tom.paperless.di

import org.koin.core.module.Module

object SharedModules {
    val commonModules: List<Module> = listOf(
        appModule
    )
}