package com.tom.paperless.data.repositories

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.Uuid


interface NfcTaggableRepository {
    @NativeCoroutines
    suspend fun add(itemToAdd: NfcTaggable): NfcTaggable
    @NativeCoroutines
    suspend fun getAll(): List<NfcTaggable>
    @NativeCoroutines
    suspend fun getById(id: Uuid): NfcTaggable?
    @NativeCoroutines
    suspend fun getAllByType(type: TagType): List<NfcTaggable>
    @NativeCoroutines
    suspend fun update(itemToUpdate: NfcTaggable): NfcTaggable?
    @NativeCoroutines
    suspend fun delete(id: Uuid): Boolean
}