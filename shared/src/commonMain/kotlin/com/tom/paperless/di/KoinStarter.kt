package com.tom.paperless.di

import com.tom.paperless.ui.viewModels.AddEmployeeViewModel
import com.tom.paperless.ui.viewModels.AssignAssetViewModel
import com.tom.paperless.ui.viewModels.CompanyViewModel
import com.tom.paperless.ui.viewModels.EmployeesViewModel
import com.tom.paperless.ui.viewModels.EmployeeDetailViewModel
import com.tom.paperless.ui.viewModels.ItemDetailViewModel
import com.tom.paperless.ui.viewModels.LoginViewModel
import com.tom.paperless.ui.viewModels.RegistrationViewModel
import com.tom.paperless.ui.viewModels.SettingsViewModel
import org.koin.core.Koin
import org.koin.core.context.startKoin
import org.koin.core.parameter.parametersOf

object KoinStarter {

    private var koinReference: Koin? = null

    fun start() {
        if (koinReference == null) {
            koinReference = startKoin { modules(appModule) }.koin
        }
    }

    fun getKoin(): Koin =
        requireNotNull(koinReference) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start() auf." }

    fun registrationViewModel(): RegistrationViewModel =
        getKoin().get(clazz = RegistrationViewModel::class)

    fun loginViewModel(): LoginViewModel =
        getKoin().get(clazz = LoginViewModel::class)

    fun settingsViewModel(): SettingsViewModel =
        getKoin().get(clazz = SettingsViewModel::class)

    fun companyViewModel(): CompanyViewModel =
        getKoin().get(clazz = CompanyViewModel::class)

    fun itemDetailViewModel(): ItemDetailViewModel =
        getKoin().get(clazz = ItemDetailViewModel::class)

    fun employeesViewModel(): EmployeesViewModel =
        getKoin().get(clazz = EmployeesViewModel::class)

    fun employeesDetailViewModel(): EmployeeDetailViewModel =
        getKoin().get(clazz = EmployeeDetailViewModel::class)

    fun assignAssetViewModel(itemIdString: String): AssignAssetViewModel =
        getKoin().get(clazz = AssignAssetViewModel::class, parameters = { parametersOf(itemIdString) })

    fun addEmployeeViewModel(): AddEmployeeViewModel =
        getKoin().get(clazz = AddEmployeeViewModel::class)
}