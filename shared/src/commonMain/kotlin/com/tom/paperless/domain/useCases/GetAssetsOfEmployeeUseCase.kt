package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.NfcTaggable
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.uuid.Uuid

class GetAssetsOfEmployeeUseCase : KoinComponent {

    private val assignmentRepository: AssignmentRepository by inject()
    private val nfcTaggableRepository: NfcTaggableRepository by inject()

    suspend operator fun invoke(employeeId: Uuid): List<NfcTaggable> {

        val assignments = assignmentRepository.getByEmployee(employeeId)
        val activeAssignments = assignments.filter { it.until == null }
        val assetIds = activeAssignments.map { it.tagId }.toSet()

        return nfcTaggableRepository
            .getAll()
            .filter { it.id in assetIds }
    }
}