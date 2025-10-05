package com.tom.paperless.data.repositories

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.domain.models.NfcTaggable
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.Uuid


interface NfcTaggableRepository {

    @NativeCoroutines
    fun observeAll(): StateFlow<List<NfcTaggable>>
    @NativeCoroutines
    suspend fun getAll(): List<NfcTaggable>

    @NativeCoroutines
    suspend fun getById(id: Uuid): NfcTaggable?

    @NativeCoroutines
    suspend fun add(itemToAdd: NfcTaggable): NfcTaggable

    @NativeCoroutines
    suspend fun update(itemToUpdate: NfcTaggable): NfcTaggable?

    @NativeCoroutines
    suspend fun delete(id: Uuid): Boolean


}