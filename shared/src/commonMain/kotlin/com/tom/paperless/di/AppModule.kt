package com.tom.paperless.di

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.AssignmentRepositoryImpl
import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.data.repositories.EmployeeRepositoryImpl
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.data.repositories.NfcTaggableRepositoryImpl
import com.tom.paperless.data.repositories.TaggableRepository
import com.tom.paperless.data.repositories.TaggableRepositoryAdapter
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
    single { GetAllNfcTaggablesFlowUseCase( repository = get()) }
    single { AddNfcTaggableUseCase(repository = get()) }
    single { SaveNfcTaggableUseCase(repository = get()) }
    single { DeleteNfcTaggableUseCase(repository = get()) }
    single { GetAllNfcTaggablesUseCase(repository = get()) }
    single { GetNfcTaggableByIdUseCase(repository = get()) }
    single { UpdateNfcTaggableUseCase(repository = get()) }

    //Employees
    single { GetAllEmployeesFlowUseCase(get()) }
    single { GetEmployeeByIdUseCase(get()) }
    single { AddEmployeeUseCase(get()) }
    single { UpdateEmployeeUseCase(get()) }
    single { DeleteEmployeeUseCase(get()) }
    single { FilterEmployeesUseCase() }


    factory {
        AssignAssetsToEmployeeUseCase(
            assignmentRepository = get<AssignmentRepository>(),
            taggableRepository = get<TaggableRepository>()
        )
    }

    factory {
        ReturnAssetsUseCase(
            assignmentRepository = get<AssignmentRepository>(),
            taggableRepository = get<TaggableRepository>()
        )
    }

    factory {
        GetAssetsOfEmployeeUseCase(
            assignmentRepository = get<AssignmentRepository>()
        )
    }

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

    factory {
        EmployeeDetailViewModel(
            getEmployeeById = get(),
            updateEmployee = get(),
            deleteEmployee = get(),
            getAssetsOfEmployee = get()
        )
    }

    factory { params ->
        val itemIdString: String = params.get()
        val itemId = kotlin.uuid.Uuid.parse(itemIdString)
        AssignAssetViewModel(
            itemId = itemId,
            employeeRepository = get(),
            assignAssetsToEmployeeUseCase = get()
        )
    }

    factory { AddEmployeeViewModel(get()) }

    factory { AddVehicleViewModel(get()) }
    factory { AddToolViewModel(get()) }
    factory { AddKeyViewModel(get()) }

}