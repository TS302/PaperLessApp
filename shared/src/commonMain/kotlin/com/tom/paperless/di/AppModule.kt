package com.tom.paperless.di

import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.data.repositories.NfcTaggableRepositoryImpl
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import com.tom.paperless.domain.useCases.DeleteNfcTaggableUseCase
import com.tom.paperless.domain.useCases.FilterNfcTaggablesUseCase
import com.tom.paperless.domain.useCases.GetAllNfcTaggablesFlowUseCase
import com.tom.paperless.domain.useCases.GetAllNfcTaggablesUseCase
import com.tom.paperless.domain.useCases.GetLoggedInUserUseCase
import com.tom.paperless.domain.useCases.GetNfcTaggableByIdUseCase
import com.tom.paperless.domain.useCases.LoginUserUseCase
import com.tom.paperless.domain.useCases.LogoutUserUseCase
import com.tom.paperless.domain.useCases.RegisterUserUseCase
import com.tom.paperless.domain.useCases.SaveNfcTaggableUseCase
import com.tom.paperless.domain.useCases.UpdateNfcTaggableUseCase
import com.tom.paperless.ui.viewModels.CompanyViewModel
import com.tom.paperless.ui.viewModels.ItemDetailViewModel
import com.tom.paperless.ui.viewModels.LoginViewModel
import com.tom.paperless.ui.viewModels.RegistrationViewModel
import com.tom.paperless.ui.viewModels.SettingsViewModel
import org.koin.dsl.module

val appModule = module {

    // Repositories
    single<NfcTaggableRepository> { NfcTaggableRepositoryImpl }

    // UseCases
    single { RegisterUserUseCase() }
    single { LoginUserUseCase() }
    single { LogoutUserUseCase() }
    single { GetLoggedInUserUseCase() }
    single { FilterNfcTaggablesUseCase() }
    single { GetAllNfcTaggablesFlowUseCase( repository = get()) }
    single { AddNfcTaggableUseCase(repository = get()) }
    single { SaveNfcTaggableUseCase(repository = get()) }
    single { DeleteNfcTaggableUseCase(repository = get()) }
    single { GetAllNfcTaggablesUseCase(repository = get()) }
    single { GetNfcTaggableByIdUseCase(repository = get()) }
    single { UpdateNfcTaggableUseCase(repository = get()) }

    //Viewmodels
    factory {
        RegistrationViewModel(
            registerUserUseCase = get<RegisterUserUseCase>(),
            loginUserUseCase = get<LoginUserUseCase>())
    }

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

    factory {
        CompanyViewModel(
            getAllNfcTaggablesFlowUseCase = get(),
            addNfcTaggableUseCase = get(),
            saveNfcTaggableUseCase = get(),
            deleteNfcTaggableUseCase = get(),
            filterNfcTaggablesUseCase = get()
        )
    }
    factory {
        ItemDetailViewModel(
            get(),
            get(),
            get()
        )
    }
}