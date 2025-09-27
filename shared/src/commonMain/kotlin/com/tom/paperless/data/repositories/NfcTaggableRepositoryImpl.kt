package com.tom.paperless.data.repositories

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TargetType
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus
import kotlin.uuid.Uuid

object NfcTaggableRepositoryImpl: NfcTaggableRepository {

    private var sampleData = mutableListOf<NfcTaggable>(
        Employee(
            id = Uuid.random(),
            name = "Clara Becker",
            email = "clara.becker@example.com",
            phoneNumber = "+49 151 0000003",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "David Wagner",
            email = "david.wagner@example.com",
            phoneNumber = "+49 151 0000004",
            tagStatus = TagStatus.available,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Elena Schulz",
            email = "elena.schulz@example.com",
            phoneNumber = "+49 151 0000005",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Felix Hoffmann",
            email = "felix.hoffmann@example.com",
            phoneNumber = "+49 151 0000006",
            tagStatus = TagStatus.available,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Greta Klein",
            email = "greta.klein@example.com",
            phoneNumber = "+49 151 0000007",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Hannah Vogel",
            email = "hannah.vogel@example.com",
            phoneNumber = "+49 151 0000008",
            tagStatus = TagStatus.available,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Jonas Krause",
            email = "jonas.krause@example.com",
            phoneNumber = "+49 151 0000009",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Laura Neumann",
            email = "laura.neumann@example.com",
            phoneNumber = "+49 151 0000010",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Employee
        ),

        // Vehicles
        Vehicle(
            id = Uuid.random(),
            name = "VW Crafter",
            plate = "RT-BC 4567",
            tagStatus = TagStatus.available,
            targetType = TargetType.Vehicle
        ),
        Vehicle(
            id = Uuid.random(),
            name = "Mercedes Vito",
            plate = "BL-DK 9876",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Vehicle
        ),
        Vehicle(
            id = Uuid.random(),
            name = "Opel Vivaro",
            plate = "TÜ-EF 1122",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Vehicle
        ),
        Vehicle(
            id = Uuid.random(),
            name = "Ford Transit",
            plate = "S-XY 4455",
            tagStatus = TagStatus.available,
            targetType = TargetType.Vehicle
        ),
        Vehicle(
            id = Uuid.random(),
            name = "Peugeot Boxer",
            plate = "BB-ZZ 3344",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Vehicle
        ),

        // Tools
        Tool(
            id = Uuid.random(),
            name = "Bosch GSR 18V",
            serialNumber = "B-GSR18V-3344",
            tagStatus = TagStatus.available,
            targetType = TargetType.Tool
        ),
        Tool(
            id = Uuid.random(),
            name = "Makita DHP482",
            serialNumber = "M-DHP482-5566",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Tool
        ),
        Tool(
            id = Uuid.random(),
            name = "Stihl Kettensäge MS 261",
            serialNumber = "S-MS261-7788",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Tool
        ),
        Tool(
            id = Uuid.random(),
            name = "Hilti TE 60",
            serialNumber = "H-TE60-9900",
            tagStatus = TagStatus.available,
            targetType = TargetType.Tool
        ),
        Tool(
            id = Uuid.random(),
            name = "Festool Absaugmobil CTL MIDI",
            serialNumber = "F-CTL-MIDI-1122",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Tool
        ),
        Tool(
            id = Uuid.random(),
            name = "DeWalt Bohrmaschine ",
            serialNumber = "D-DWD024-2233",
            tagStatus = TagStatus.available,
            targetType = TargetType.Tool
        ),

        // KeyRings → TargetType.Key
        KeyRing(
            id = Uuid.random(),
            name = "Nebeneingang Lagerhalle",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Serverraum Schlüssel",
            tagStatus = TagStatus.available,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Büro 1.OG",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Werkstatt Schlüsselbund",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Kellerschlüssel Verwaltung",
            tagStatus = TagStatus.available,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Ersatzschlüssel Fuhrpark",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Zentralschlüssel Hauptgebäude",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Schlüsselbund Hausmeister",
            tagStatus = TagStatus.available,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Garagenschlüssel Büro",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Key
        ),
        KeyRing(
            id = Uuid.random(),
            name = "Tresorschlüssel Verwaltung",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Key
        )
    )

    @NativeCoroutines
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