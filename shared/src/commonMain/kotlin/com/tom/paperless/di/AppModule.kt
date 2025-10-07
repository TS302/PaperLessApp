package com.tom.paperless.di

import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.data.repositories.EmployeeRepositoryImpl
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.data.repositories.NfcTaggableRepositoryImpl
import com.tom.paperless.domain.useCases.AddEmployeeUseCase
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import com.tom.paperless.domain.useCases.DeleteEmployeeUseCase
import com.tom.paperless.domain.useCases.DeleteNfcTaggableUseCase
import com.tom.paperless.domain.useCases.FilterEmployeesUseCase
import com.tom.paperless.domain.useCases.FilterNfcTaggablesUseCase
import com.tom.paperless.domain.useCases.GetAllEmployeesFlowUseCase
import com.tom.paperless.domain.useCases.GetAllNfcTaggablesFlowUseCase
import com.tom.paperless.domain.useCases.GetAllNfcTaggablesUseCase
import com.tom.paperless.domain.useCases.GetLoggedInUserUseCase
import com.tom.paperless.domain.useCases.GetNfcTaggableByIdUseCase
import com.tom.paperless.domain.useCases.LoginUserUseCase
import com.tom.paperless.domain.useCases.LogoutUserUseCase
import com.tom.paperless.domain.useCases.RegisterUserUseCase
import com.tom.paperless.domain.useCases.SaveNfcTaggableUseCase
import com.tom.paperless.domain.useCases.UpdateEmployeeUseCase
import com.tom.paperless.domain.useCases.UpdateNfcTaggableUseCase
import com.tom.paperless.ui.viewModels.CompanyViewModel
import com.tom.paperless.ui.viewModels.EmployeesViewModel
import com.tom.paperless.ui.viewModels.ItemDetailViewModel
import com.tom.paperless.ui.viewModels.LoginViewModel
import com.tom.paperless.ui.viewModels.RegistrationViewModel
import com.tom.paperless.ui.viewModels.SettingsViewModel
import org.koin.dsl.module

val appModule = module {

    // Repositories
    single<NfcTaggableRepository> { NfcTaggableRepositoryImpl }
    single<EmployeeRepository> { EmployeeRepositoryImpl }

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

    single { GetAllEmployeesFlowUseCase(get()) }
    single { AddEmployeeUseCase(get()) }
    single { UpdateEmployeeUseCase(get()) }
    single { DeleteEmployeeUseCase(get()) }
    single { FilterEmployeesUseCase() }

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

    factory {
        EmployeesViewModel(
            getAllEmployeesFlow = get(),
            addEmployee = get(),
            updateEmployee = get(),
            deleteEmployee = get(),
            filterEmployees = get()
        )
    }
}