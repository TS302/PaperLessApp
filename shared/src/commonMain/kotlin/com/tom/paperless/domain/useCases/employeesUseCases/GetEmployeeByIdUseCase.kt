package com.tom.paperless.domain.useCases.employeesUseCases

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.data.repositories.EmployeeRepository
import com.tom.paperless.domain.models.Employee
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class GetEmployeeByIdUseCase() : KoinComponent {
    private val repository: EmployeeRepository by inject()

    @NativeCoroutines
    suspend operator fun invoke(id: Uuid): Employee? =
        repository.getById(id)
}