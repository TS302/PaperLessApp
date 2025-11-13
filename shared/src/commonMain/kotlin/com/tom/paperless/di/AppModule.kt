package com.tom.paperless.di


import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.AssignmentRepositoryImpl
import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.data.repositories.EmployeeRepositoryImpl
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.data.repositories.NfcTaggableRepositoryImpl
import com.tom.paperless.data.repositories.TaggableRepository
import com.tom.paperless.data.repositories.TaggableRepositoryAdapter
import com.tom.paperless.data.repositories.UserRepository
import com.tom.paperless.domain.useCases.*
import com.tom.paperless.domain.useCases.assetsUseCases.AssignAssetToEmployeeUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.AssignAssetsToEmployeeUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.GetAssetsOfEmployeeUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.ReturnAssetUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.ReturnAssetsUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.*
import com.tom.paperless.ui.viewModels.*
import org.koin.dsl.module
import kotlin.uuid.Uuid

val appModule = module {

    // Repositories (shared)
    single<UserRepository> { UserRepository }
    single<NfcTaggableRepository> { NfcTaggableRepositoryImpl() }
    single<EmployeeRepository> { EmployeeRepositoryImpl }
    single<TaggableRepository> { TaggableRepositoryAdapter(get()) }
    single<AssignmentRepository> { AssignmentRepositoryImpl(get(), get()) }

    // Auth UseCases (shared)
    single { RegisterUserUseCase() }
    single { LoginUserUseCase() }
    single { LogoutUserUseCase() }
    single { GetLoggedInUserUseCase() }
    single { CheckUserLoggedInUseCase() }

    // NfcTaggables UseCases
    single { FilterNfcTaggablesUseCase() }
    single { GetAllNfcTaggablesFlowUseCase() }
    single { AddNfcTaggableUseCase() }
    single { SaveNfcTaggableUseCase() }
    single { DeleteNfcTaggableUseCase() }
    single { GetAllNfcTaggablesUseCase() }
    single { GetNfcTaggableByIdUseCase() }
    single { UpdateNfcTaggableUseCase() }

    // Employees UseCases
    single { GetAllEmployeesFlowUseCase() }
    single { GetEmployeeByIdUseCase() }
    single { AddEmployeeUseCase() }
    single { UpdateEmployeeUseCase() }
    single { DeleteEmployeeUseCase() }
    single { FilterEmployeesUseCase() }

    // Assignment UseCases
    single { AssignAssetsToEmployeeUseCase() }
    single { AssignAssetToEmployeeUseCase() }
    single { ReturnAssetUseCase() }
    single { ReturnAssetsUseCase() }
    single { GetAssetsOfEmployeeUseCase() }

    // ViewModels (shared)
    factory { CompanyViewModel() }
    factory { EmployeesViewModel() }
    factory { EmployeeDetailViewModel() }
    factory { AddEmployeeViewModel() }
    factory { AddToolViewModel() }
    factory { AddVehicleViewModel() }
    factory { AddKeyViewModel() }
    factory { LoginViewModel() }
    factory { RegistrationViewModel() }
    factory { SettingsViewModel() }
    factory { ItemDetailViewModel() }
    factory { AssignAssetViewModel() }
}