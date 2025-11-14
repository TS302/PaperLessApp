package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.Employee
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class UpdateEmployeeUseCase() : KoinComponent {
    private val repository: EmployeeRepository by inject()

    suspend operator fun invoke(employee: Employee): Employee {
        val cleaned = employee.copy(name = employee.name.trim())
        require(cleaned.name.isNotBlank()) { "Name darf nicht leer sein." }
        return repository.update(cleaned) ?: error("Mitarbeiter nicht gefunden.")
    }
}