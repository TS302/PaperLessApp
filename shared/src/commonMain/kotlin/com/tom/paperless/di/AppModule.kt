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
import com.tom.paperless.domain.services.VehicleService
import com.tom.paperless.domain.services.VehicleServiceImpl
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
import com.tom.paperless.domain.useCases.assetsUseCases.AssignAssetsToEmployeeUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.GetAssetsOfEmployeeUseCase
import com.tom.paperless.domain.useCases.assetsUseCases.ReturnAssetsUseCase
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
import com.tom.paperless.ui.viewModels.ItemDetailViewModel
import com.tom.paperless.ui.viewModels.LoginViewModel
import com.tom.paperless.ui.viewModels.RegistrationViewModel
import com.tom.paperless.ui.viewModels.SettingsViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import org.koin.dsl.module

val appModule = module {

    single<CoroutineScope> { CoroutineScope(SupervisorJob() + Dispatchers.Default) }

    // Repositories
    single<UserRepository>{ UserRepository }
    single<NfcTaggableRepository> { NfcTaggableRepositoryImpl() }
    single<EmployeeRepository> { EmployeeRepositoryImpl }
    single<TaggableRepository> { TaggableRepositoryAdapter(get<NfcTaggableRepository>()) }
    single<AssignmentRepository> { AssignmentRepositoryImpl(get(), get()) }

    single<VehicleService> { VehicleServiceImpl(get(), get()) }

    // UseCases
    single { RegisterUserUseCase() }
    single { LoginUserUseCase() }
    single { LogoutUserUseCase() }
    single { GetLoggedInUserUseCase() }

    //NfcTaggables
    single { FilterNfcTaggablesUseCase() }
    single { GetAllNfcTaggablesFlowUseCase() }
    single { AddNfcTaggableUseCase() }
    single { SaveNfcTaggableUseCase() }
    single { DeleteNfcTaggableUseCase() }
    single { GetAllNfcTaggablesUseCase() }
    single { GetNfcTaggableByIdUseCase() }
    single { UpdateNfcTaggableUseCase() }

    //Employees
    single { GetAllEmployeesFlowUseCase() }
    single { GetEmployeeByIdUseCase() }
    single { AddEmployeeUseCase() }
    single { UpdateEmployeeUseCase() }
    single { DeleteEmployeeUseCase() }
    single { FilterEmployeesUseCase() }

    // Assignment
    single { AssignAssetsToEmployeeUseCase() }
    single { ReturnAssetsUseCase() }
    single { GetAssetsOfEmployeeUseCase() }

    //Viewmodels
    factory { CompanyViewModel() }
    factory { AddEmployeeViewModel() }
    factory { AddKeyViewModel() }
    factory { AddToolViewModel() }
    factory { AddVehicleViewModel() }
    factory { EmployeeDetailViewModel() }
    factory { EmployeesViewModel() }
    factory { ItemDetailViewModel() }
    factory { LoginViewModel() }
    factory { SettingsViewModel() }

    factory { RegistrationViewModel() }
    factory { params ->
        val itemIdString: String = params.get()
        val itemId = kotlin.uuid.Uuid.parse(itemIdString)
        AssignAssetViewModel(itemId = itemId)
    }
}