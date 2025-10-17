package com.tom.paperless.domain.useCases.assetsUseCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.NfcTaggable
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class GetAssetsOfEmployeeUseCase() : KoinComponent{

    private val assignmentRepository: AssignmentRepository by inject()

    suspend operator fun invoke(employeeId: Uuid): List<NfcTaggable> {
        return assignmentRepository.assetsOf(employeeId)
    }
}