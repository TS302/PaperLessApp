package com.tom.paperless.domain.useCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.Employee
import kotlinx.coroutines.flow.StateFlow

class GetAllEmployeesFlowUseCase(
    private val repository: EmployeeRepository
) {
    @NativeCoroutines
    operator fun invoke(): StateFlow<List<Employee>> = repository.observeAll()
}