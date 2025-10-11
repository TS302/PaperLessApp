package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagStatus
import kotlin.uuid.Uuid

interface TaggableRepository {
    suspend fun getById(id: Uuid): NfcTaggable?
    suspend fun getByIds(ids: List<Uuid>): List<NfcTaggable>
    suspend fun updateStatus(id: Uuid, status: TagStatus): NfcTaggable
}