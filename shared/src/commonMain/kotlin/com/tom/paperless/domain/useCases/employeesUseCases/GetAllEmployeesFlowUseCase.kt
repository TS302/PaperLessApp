package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.Employee
import kotlinx.coroutines.flow.Flow
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class GetAllEmployeesFlowUseCase() : KoinComponent {
    private val repository: EmployeeRepository by inject()
    operator fun invoke(): Flow<List<Employee>> = repository.getAllFlow()
}