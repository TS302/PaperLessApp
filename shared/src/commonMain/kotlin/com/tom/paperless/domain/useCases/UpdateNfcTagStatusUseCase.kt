package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.NfcTaggableRepository
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class UpdateNfcTagStatusUseCase() : KoinComponent {
    private val repository: NfcTaggableRepository by inject()
    suspend operator fun invoke(
        id: kotlin.uuid.Uuid,
        status: TagStatus
    ): NfcTaggable {

        val current = repository.getById(id)
            ?: error("NfcTaggable mit ID $id nicht gefunden")

        val updated = when (current) {
            is Tool ->
                current.copy(tagStatus = status)

            is Vehicle ->
                current.copy(tagStatus = status)

            is KeyRing ->
                current.copy(tagStatus = status)

            is AssetUser ->
                current.copy(tagStatus = status)
        }

        return repository.update(updated)
            ?: error("Update des NfcTaggable fehlgeschlagen")
    }
}