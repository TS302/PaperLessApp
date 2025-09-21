package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.TargetType
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import kotlin.uuid.Uuid

object NfcTaggableRepositoryImpl: NfcTaggableRepository {

    private var sampleData = mutableListOf(
        Employee(
            id = Uuid.parse("00000000-0000-0000-0000-0000000000E1"),
            name = "Anna Müller",
            email = "anna.mueller@example.com",
            phoneNumber = "+49 151 0000001"
        ),
        Employee(
            id = Uuid.parse("00000000-0000-0000-0000-0000000000E2"),
            name = "Ben Schmidt",
            email = "ben.schmidt@example.com",
            phoneNumber = "+49 151 0000002"
        ),
        // Vehicle
        Vehicle(
            id = Uuid.parse("00000000-0000-0000-0000-0000000000V1"),
            name = "Sprinter 316",
            plate = "TÜ-AB 1234"
        ),
        // Tool
        Tool(
            id = Uuid.parse("00000000-0000-0000-0000-0000000000T1"),
            name = "Hilti TE 50",
            serialNumber = "H-TE50-7788"
        ),
        // Key
        KeyRing(
            id = Uuid.parse("00000000-0000-0000-0000-0000000000K1"),
            name = "Hauptschlüssel Zentrale"
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