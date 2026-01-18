package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.Assignment
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.getValue

class ObserveAllAssignmentsUseCase : KoinComponent {
    private val repository: AssignmentRepository by inject()

    fun observe(onChange: (List<Assignment>) -> Unit) {
        repository.observeAll(onChange)
    }

    fun stop() {
        repository.stopObserving()
    }

    suspend fun load(): List<Assignment> {
        return repository.getAll()
    }
}
