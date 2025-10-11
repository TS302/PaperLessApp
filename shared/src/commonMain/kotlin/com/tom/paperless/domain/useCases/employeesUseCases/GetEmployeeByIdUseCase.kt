package com.tom.paperless.domain.useCases.employeesUseCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.Employee
import kotlin.uuid.Uuid

class GetEmployeeByIdUseCase(
    private val repository: EmployeeRepository
) {
    @NativeCoroutines
    suspend operator fun invoke(id: Uuid): Employee? =
        repository.getById(id)
}