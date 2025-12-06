package com.tom.paperless.di


import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.AssignmentRepositoryImpl
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.data.repositories.AssetUserRepositoryImpl
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.data.repositories.NfcTaggableRepositoryImpl
import com.tom.paperless.data.repositories.UserRepository
import com.tom.paperless.domain.useCases.AddNfcTaggableUseCase
import com.tom.paperless.domain.useCases.CheckUserLoggedInUseCase
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
import com.tom.paperless.domain.useCases.assetsUseCases.AssignAssetToEmployeeUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.GetAssetsOfEmployeeUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.ReturnAssetUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.AddAssetUserUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.DeleteAssetUserUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.FilterAssetUsersUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.GetAllAssetUsersUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.GetAssetUserByIdUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.UpdateAssetUserUseCase
import com.tom.paperless.ui.viewModels.AddAssetUserViewModel
import com.tom.paperless.ui.viewModels.AddKeyViewModel
import com.tom.paperless.ui.viewModels.AddToolViewModel
import com.tom.paperless.ui.viewModels.AddVehicleViewModel
import com.tom.paperless.ui.viewModels.AssignAssetViewModel
import com.tom.paperless.ui.viewModels.AssetsViewModel
import com.tom.paperless.ui.viewModels.AssetUserDetailViewModel
import com.tom.paperless.ui.viewModels.AssetUsersViewModel
import com.tom.paperless.ui.viewModels.AssetDetailViewModel
import com.tom.paperless.ui.viewModels.EditAssetSheetViewModel
import com.tom.paperless.ui.viewModels.EditAssetUserViewModel
import com.tom.paperless.ui.viewModels.LoginViewModel
import com.tom.paperless.ui.viewModels.RegistrationViewModel
import com.tom.paperless.ui.viewModels.SettingsViewModel
import org.koin.dsl.module

val appModule = module {

    // Repositories
    single<UserRepository> { UserRepository }
    single<NfcTaggableRepository> { NfcTaggableRepositoryImpl() }
    single<AssetUserRepository> { AssetUserRepositoryImpl }
    single<AssignmentRepository> { AssignmentRepositoryImpl(get(), get()) }

    // Auth UseCases
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
    single { GetAllAssetUsersUseCase() }
    single { GetAssetUserByIdUseCase() }
    single { AddAssetUserUseCase() }
    single { UpdateAssetUserUseCase() }
    single { DeleteAssetUserUseCase() }
    single { FilterAssetUsersUseCase() }

    // Assignment UseCases
    single { AssignAssetToEmployeeUseCase() }
    single { ReturnAssetUseCase() }
    single { GetAssetsOfEmployeeUseCase() }

    // ViewModels
    factory { AssetsViewModel() }
    factory { AssetUsersViewModel() }
    factory { AssetUserDetailViewModel() }
    factory { AddAssetUserViewModel() }
    factory { AddToolViewModel() }
    factory { AddVehicleViewModel() }
    factory { AddKeyViewModel() }
    factory { LoginViewModel() }
    factory { RegistrationViewModel() }
    factory { SettingsViewModel() }
    factory { AssetDetailViewModel() }
    factory { AssignAssetViewModel() }
    factory { EditAssetSheetViewModel() }
    factory { EditAssetUserViewModel() }
}