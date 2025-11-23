package com.tom.paperless.di


import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.AssignmentRepositoryImpl
import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.data.repositories.EmployeeRepositoryImpl
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
import com.tom.paperless.domain.useCases.employeesUseCases.AddEmployeeUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.DeleteEmployeeUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.FilterEmployeesUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.GetAllEmployeesFlowUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.GetEmployeeByIdUseCase
import com.tom.paperless.domain.useCases.employeesUseCases.UpdateEmployeeUseCase
import com.tom.paperless.ui.viewModels.AddEmployeeViewModel
import com.tom.paperless.ui.viewModels.AddKeyViewModel
import com.tom.paperless.ui.viewModels.AddToolViewModel
import com.tom.paperless.ui.viewModels.AddVehicleViewModel
import com.tom.paperless.ui.viewModels.AssignAssetViewModel
import com.tom.paperless.ui.viewModels.CompanyViewModel
import com.tom.paperless.ui.viewModels.EmployeeDetailViewModel
import com.tom.paperless.ui.viewModels.EmployeesViewModel
import com.tom.paperless.ui.viewModels.AssetDetailViewModel
import com.tom.paperless.ui.viewModels.EditAssetSheetViewModel
import com.tom.paperless.ui.viewModels.EditEmployeeViewModel
import com.tom.paperless.ui.viewModels.LoginViewModel
import com.tom.paperless.ui.viewModels.RegistrationViewModel
import com.tom.paperless.ui.viewModels.SettingsViewModel
import org.koin.dsl.module

val appModule = module {

    // Repositories
    single<UserRepository> { UserRepository }
    single<NfcTaggableRepository> { NfcTaggableRepositoryImpl() }
    single<EmployeeRepository> { EmployeeRepositoryImpl }
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
    single { GetAllEmployeesFlowUseCase() }
    single { GetEmployeeByIdUseCase() }
    single { AddEmployeeUseCase() }
    single { UpdateEmployeeUseCase() }
    single { DeleteEmployeeUseCase() }
    single { FilterEmployeesUseCase() }

    // Assignment UseCases
    single { AssignAssetToEmployeeUseCase() }
    single { ReturnAssetUseCase() }
    single { GetAssetsOfEmployeeUseCase() }

    // ViewModels
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
    factory { AssetDetailViewModel() }
    factory { AssignAssetViewModel() }
    factory { EditAssetSheetViewModel() }
    factory { EditEmployeeViewModel() }
}