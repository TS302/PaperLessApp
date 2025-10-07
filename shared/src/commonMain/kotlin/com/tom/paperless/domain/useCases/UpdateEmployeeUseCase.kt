package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.Employee

class UpdateEmployeeUseCase(
    private val repository: EmployeeRepository
) {
    suspend operator fun invoke(employee: Employee): Employee {
        require(employee.name.isNotBlank()) { "Name darf nicht leer sein." }
        return repository.update(employee)
            ?: error("Mitarbeiter nicht gefunden.")
    }
}