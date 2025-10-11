package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.Employee
import kotlinx.coroutines.flow.Flow

class GetAllEmployeesFlowUseCase(
    private val repository: EmployeeRepository
) {
    operator fun invoke(): Flow<List<Employee>> = repository.getAllFlow()
}