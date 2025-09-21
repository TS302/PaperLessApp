package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.TargetType
import kotlin.uuid.Uuid

interface NfcTaggableRepository {
    suspend fun getAll(): List<NfcTaggable>
    suspend fun getById(type: TargetType, id: Uuid): NfcTaggable?
    suspend fun add(item: NfcTaggable): NfcTaggable
    suspend fun update(item: NfcTaggable): Boolean
}