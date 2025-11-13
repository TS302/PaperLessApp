package com.tom.paperless.di

import android.app.Application
import com.tom.paperless.ui.viewModels.*
import org.koin.android.ext.koin.androidContext
import org.koin.core.Koin
import org.koin.core.context.startKoin

object KoinStarter {

    private var koinRef: Koin? = null
    fun start(application: Application) {
        if (koinRef == null) {
            koinRef = startKoin {
                androidContext(application)
                modules(
                    SharedModules.commonModules + AndroidPlatformModules.platformModules
                )
            }.koin
        }
    }

    private fun getKoin(): Koin =
        requireNotNull(koinRef) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start(application) auf." }

    fun companyViewModel(): CompanyViewModel =
        getKoin().get(clazz = CompanyViewModel::class)

    fun employeesViewModel(): EmployeesViewModel =
        getKoin().get(clazz = EmployeesViewModel::class)

    fun loginViewModel(): LoginViewModel =
        getKoin().get(clazz = LoginViewModel::class)

    fun registrationViewModel(): RegistrationViewModel =
        getKoin().get(clazz = RegistrationViewModel::class)

    fun settingsViewModel(): SettingsViewModel =
        getKoin().get(clazz = SettingsViewModel::class)

    fun employeeDetailViewModel(): EmployeeDetailViewModel =
        getKoin().get(clazz = EmployeeDetailViewModel::class)

    fun addEmployeeViewModel(): AddEmployeeViewModel =
        getKoin().get(clazz = AddEmployeeViewModel::class)

    fun addToolViewModel(): AddToolViewModel =
        getKoin().get(clazz = AddToolViewModel::class)

    fun addVehicleViewModel(): AddVehicleViewModel =
        getKoin().get(clazz = AddVehicleViewModel::class)

    fun addKeyViewModel(): AddKeyViewModel =
        getKoin().get(clazz = AddKeyViewModel::class)

    fun itemDetailViewModel(): ItemDetailViewModel =
        getKoin().get(clazz = ItemDetailViewModel::class)

    fun assignAssetViewModel(): AssignAssetViewModel =
        getKoin().get(clazz = AssignAssetViewModel::class)
}