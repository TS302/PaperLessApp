package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.TargetType
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import kotlin.uuid.Uuid

object NfcTaggableRepositoryImpl: NfcTaggableRepository {

    private var sampleData = mutableListOf<NfcTaggable>(
        Employee(
            id = Uuid.random(), name = "Anna Müller",
            email = "anna.mueller@example.com", phoneNumber = "+49 151 0000001"
        ),
        Employee(
            id = Uuid.random(), name = "Ben Schmidt",
            email = "ben.schmidt@example.com", phoneNumber = "+49 151 0000002"
        ),
        Vehicle(
            id = Uuid.random(), name = "Sprinter 316", plate = "TÜ-AB 1234"
        ),
        Tool(
            id = Uuid.random(), name = "Hilti TE 50", serialNumber = "H-TE50-7788"
        ),
        KeyRing(
            id = Uuid.random(), name = "Hauptschlüssel Zentrale"
        )
    )

    override suspend fun getAll(): List<NfcTaggable> {
        return sampleData
    }

    override suspend fun getById(type: TargetType, id: Uuid): NfcTaggable? {
        return sampleData.firstOrNull { it.targetType == type && it.id == id }
    }

    override suspend fun add(item: NfcTaggable): NfcTaggable {
        require(item.name.isNotBlank()) { "Name darf nicht leer sein." }
        require(sampleData.none { it.id == item.id && it.targetType == item.targetType }) {
            "${item.targetType} mit ID ${item.id} existiert bereits."
        }
        sampleData.add(item)
        return item
    }

    override suspend fun update(item: NfcTaggable): Boolean {
        val index = sampleData.indexOfFirst { it.id == item.id && it.targetType == item.targetType }
        return if (index >= 0) {
            sampleData[index] = item
            true
        } else {
            false
        }
    }

}