package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus
import kotlin.uuid.Uuid

class TaggableRepositoryAdapter(
    private val nfcRepo: NfcTaggableRepository
) : TaggableRepository {

    override suspend fun getById(id: Uuid) = nfcRepo.getById(id)

    override suspend fun getByIds(ids: List<Uuid>): List<NfcTaggable> {
        val set = ids.toSet()
        return nfcRepo.getAll().filter { it.id in set }
    }

    override suspend fun updateStatus(id: Uuid, status: TagStatus): NfcTaggable {
        val current = nfcRepo.getById(id) ?: error("Taggable $id existiert nicht.")
        val updated = when (current) {
            is Tool -> current.copy(tagStatus = status)
            is Vehicle -> current.copy(tagStatus = status)
            is KeyRing -> current.copy(tagStatus = status)
            else -> error("Unbekannter Typ: ${current::class.simpleName}")
        }
        return nfcRepo.update(updated) ?: error("Update fehlgeschlagen.")
    }
}