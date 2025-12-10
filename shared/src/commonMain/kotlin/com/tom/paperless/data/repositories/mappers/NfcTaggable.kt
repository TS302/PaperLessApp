package com.tom.paperless.data.repositories.mappers

import com.tom.paperless.data.repositories.dto.NfcTaggableDto
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

fun NfcTaggable.toDto(): NfcTaggableDto {
    return when (this) {
        is Tool -> NfcTaggableDto(
            id = id.toString(),
            name = name,
            tagType = tagType.name,
            tagStatus = tagStatus.name,
            currentAssigneeId = currentAssigneeId?.toString(),
            lastAssigneeIds = lastAssigneeIds.map { it.toString() },
            brand = brand,
            serialNumber = serialNumber,
            note = note
        )

        is Vehicle -> NfcTaggableDto(
            id = id.toString(),
            name = name,
            tagType = tagType.name,
            tagStatus = tagStatus.name,
            currentAssigneeId = currentAssigneeId?.toString(),
            lastAssigneeIds = lastAssigneeIds.map { it.toString() },
            plate = plate,
            brand = brand,
            note = note
        )

        is KeyRing -> NfcTaggableDto(
            id = id.toString(),
            name = name,
            tagType = tagType.name,
            tagStatus = tagStatus.name,
            currentAssigneeId = currentAssigneeId?.toString(),
            lastAssigneeIds = lastAssigneeIds.map { it.toString() },
            serialNumber = serialNumber,
            note = note
        )

        is AssetUser -> NfcTaggableDto(
            id = id.toString(),
            name = name,
            tagType = tagType.name,
            tagStatus = tagStatus.name,
            currentAssigneeId = currentAssigneeId?.toString(),
            lastAssigneeIds = lastAssigneeIds.map { it.toString() },
            note = note
        )
    }
}

fun NfcTaggableDto.toToolDomain(): Tool {
    return Tool(
        id = Uuid.parse(id),
        name = name,
        tagType = TagType.Tool,
        tagStatus = TagStatus.valueOf(tagStatus),
        currentAssigneeId = currentAssigneeId?.let { Uuid.parse(it) },
        lastAssigneeIds = lastAssigneeIds.map { Uuid.parse(it) },
        brand = brand,
        serialNumber = serialNumber,
        note = note
    )
}

fun NfcTaggableDto.toVehicleDomain(): Vehicle {
    return Vehicle(
        id = Uuid.parse(id),
        name = name,
        plate = plate,
        brand = brand,
        tagType = TagType.Vehicle,
        tagStatus = TagStatus.valueOf(tagStatus),
        currentAssigneeId = currentAssigneeId?.let { Uuid.parse(it) },
        lastAssigneeIds = lastAssigneeIds.map { Uuid.parse(it) },
        note = note
    )
}

fun NfcTaggableDto.toKeyRingDomain(): KeyRing {
    return KeyRing(
        id = Uuid.parse(id),
        name = name,
        serialNumber = serialNumber,
        tagType = TagType.Key,
        tagStatus = TagStatus.valueOf(tagStatus),
        currentAssigneeId = currentAssigneeId?.let { Uuid.parse(it) },
        lastAssigneeIds = lastAssigneeIds.map { Uuid.parse(it) },
        note = note
    )
}

fun NfcTaggableDto.toAssetUserDomain(): AssetUser {
    return AssetUser(
        id = Uuid.parse(id),
        name = name,
        email = "", // optional: kann man später erweitern
        phoneNumber = "", // optional
        tagType = TagType.AssetUser,
        tagStatus = TagStatus.valueOf(tagStatus),
        currentAssigneeId = currentAssigneeId?.let { Uuid.parse(it) },
        lastAssigneeIds = lastAssigneeIds.map { Uuid.parse(it) },
        note = note
    )
}