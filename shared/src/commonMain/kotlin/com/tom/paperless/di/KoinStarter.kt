package com.tom.paperless.di

import com.tom.paperless.ui.viewModels.CompanyViewModel
import com.tom.paperless.ui.viewModels.EmployeesViewModel
import com.tom.paperless.ui.viewModels.EmployeeDetailViewModel
import com.tom.paperless.ui.viewModels.ItemDetailViewModel
import com.tom.paperless.ui.viewModels.LoginViewModel
import com.tom.paperless.ui.viewModels.RegistrationViewModel
import com.tom.paperless.ui.viewModels.SettingsViewModel
import org.koin.core.Koin
import org.koin.core.context.startKoin

object KoinStarter {

    private var koinReference: Koin? = null

    fun start() {
        if (koinReference == null) {
            koinReference = startKoin { modules(appModule) }.koin
        }
    }

    fun registrationViewModel(): RegistrationViewModel =
        requireNotNull(koinReference) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start() auf." }
            .get(clazz = RegistrationViewModel::class)

    fun loginViewModel(): LoginViewModel =
        requireNotNull(koinReference) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start() auf." }
            .get(clazz = LoginViewModel::class)

    fun settingsViewModel(): SettingsViewModel =
        requireNotNull(koinReference) { "KoinStarter.start() zuerst aufrufen." }
            .get(clazz = SettingsViewModel::class)

    fun companyViewModel(): CompanyViewModel =
        requireNotNull(koinReference) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start() auf." }
            .get(clazz = CompanyViewModel::class)

    fun itemDetailViewModel(): ItemDetailViewModel =
        requireNotNull(koinReference) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start() auf." }
            .get(clazz = ItemDetailViewModel::class)

    fun employeesViewModel(): EmployeesViewModel =
        requireNotNull(koinReference) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start() auf." }
            .get(clazz = EmployeesViewModel::class)

    fun employeesDetailViewModel(): EmployeeDetailViewModel =
        requireNotNull(koinReference) { "Koin wurde noch nicht gestartet. Rufe zuerst KoinStarter.start() auf." }
            .get (clazz = EmployeeDetailViewModel::class)
}