package com.tom.paperless.di

import com.tom.paperless.domain.useCases.GetLoggedInUserUseCase
import com.tom.paperless.domain.useCases.LoginUserUseCase
import com.tom.paperless.domain.useCases.LogoutUserUseCase
import com.tom.paperless.domain.useCases.RegisterUserUseCase
import com.tom.paperless.ui.viewModels.LoginViewModel
import com.tom.paperless.ui.viewModels.RegistrationViewModel
import com.tom.paperless.ui.viewModels.SettingsViewModel
import org.koin.dsl.module

val appModule = module {
    single { RegisterUserUseCase() }
    single { LoginUserUseCase() }
    single { LogoutUserUseCase() }
    single { GetLoggedInUserUseCase() }

    factory {
        RegistrationViewModel(
            registerUserUseCase = get<RegisterUserUseCase>(),
            loginUserUseCase = get<LoginUserUseCase>()) }
    factory {
        LoginViewModel(
            loginUserUseCase = get<LoginUserUseCase>(),
            getLoggedInUserUseCase = get<GetLoggedInUserUseCase>(),
            logoutUserUseCase = get<LogoutUserUseCase>()
        )
    }
    factory {
        SettingsViewModel(
            logoutUserUseCase = get<LogoutUserUseCase>()
        )
    }
}