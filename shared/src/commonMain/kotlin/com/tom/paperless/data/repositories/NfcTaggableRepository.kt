package com.tom.paperless.data.repositories

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TargetType
import kotlin.native.HiddenFromObjC
import kotlin.uuid.Uuid


interface NfcTaggableRepository {

    @NativeCoroutines
    suspend fun getAll(): List<NfcTaggable>

    @HiddenFromObjC
    suspend fun getById(type: TargetType, id: Uuid): NfcTaggable?

    @HiddenFromObjC
    suspend fun add(item: NfcTaggable): NfcTaggable

    @HiddenFromObjC
    suspend fun update(item: NfcTaggable): Boolean
}