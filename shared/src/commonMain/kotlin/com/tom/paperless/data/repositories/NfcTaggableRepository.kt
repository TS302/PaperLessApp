package com.tom.paperless.data.repositories

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.Uuid


interface NfcTaggableRepository {
    suspend fun add(itemToAdd: NfcTaggable): NfcTaggable
    suspend fun getAll(): List<NfcTaggable>
    suspend fun getById(id: Uuid): NfcTaggable?
    suspend fun update(itemToUpdate: NfcTaggable): NfcTaggable?
    suspend fun delete(id: Uuid): Boolean

    fun observeAll(onChange: (List<NfcTaggable>) -> Unit)
    fun stopObserving()
}