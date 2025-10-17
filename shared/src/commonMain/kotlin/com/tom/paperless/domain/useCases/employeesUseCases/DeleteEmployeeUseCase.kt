package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.data.repositories.EmployeeRepository
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class DeleteEmployeeUseCase() : KoinComponent {

    private val repository: EmployeeRepository by inject()

    suspend operator fun invoke(id: Uuid): Boolean = repository.delete(id)
}