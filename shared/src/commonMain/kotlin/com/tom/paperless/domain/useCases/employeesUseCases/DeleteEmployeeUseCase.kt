package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.data.repositories.EmployeeRepository
import kotlin.uuid.Uuid

class DeleteEmployeeUseCase(
    private val repository: EmployeeRepository
) {
    suspend operator fun invoke(id: Uuid): Boolean = repository.delete(id)
}