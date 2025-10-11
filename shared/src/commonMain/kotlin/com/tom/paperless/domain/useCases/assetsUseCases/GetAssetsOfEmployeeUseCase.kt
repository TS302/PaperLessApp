package com.tom.paperless.domain.useCases.assetsUseCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.domain.models.NfcTaggable
import kotlin.uuid.Uuid

class GetAssetsOfEmployeeUseCase(
    private val assignmentRepository: AssignmentRepository
) {

    suspend operator fun invoke(employeeId: Uuid): List<NfcTaggable> {
        return assignmentRepository.assetsOf(employeeId)
    }
}