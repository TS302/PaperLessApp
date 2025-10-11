package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.Employee

class UpdateEmployeeUseCase(
    private val repository: EmployeeRepository
) {
    suspend operator fun invoke(employee: Employee): Employee {
        val cleaned = employee.copy(name = employee.name.trim())
        require(cleaned.name.isNotBlank()) { "Name darf nicht leer sein." }
        return repository.update(cleaned) ?: error("Mitarbeiter nicht gefunden.")
    }
}