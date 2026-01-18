package com.tom.paperless.data.repositories.mappers

import com.tom.paperless.data.repositories.dto.NfcTaggableDto
import com.tom.paperless.domain.models.*
import com.tom.paperless.domain.models.enums.TagType

fun nfcTaggableToDto(item: NfcTaggable): NfcTaggableDto {
    return when (item) {

        is Tool -> NfcTaggableDto(
            id = item.id.toString(),
            name = item.name,
            tagType = TagType.Tool.name,
            tagStatus = item.tagStatus.name,
            currentAssigneeId = item.currentAssigneeId?.toString(),
            lastAssigneeIds = item.lastAssigneeIds.map { it.toString() },
            brand = item.brand,
            serialNumber = item.serialNumber,
            note = item.note
        )

        is Vehicle -> NfcTaggableDto(
            id = item.id.toString(),
            name = item.name,
            tagType = TagType.Vehicle.name,
            tagStatus = item.tagStatus.name,
            currentAssigneeId = item.currentAssigneeId?.toString(),
            lastAssigneeIds = item.lastAssigneeIds.map { it.toString() },
            plate = item.plate,
            brand = item.brand,
            note = item.note
        )

        is KeyRing -> NfcTaggableDto(
            id = item.id.toString(),
            name = item.name,
            tagType = TagType.Key.name,
            tagStatus = item.tagStatus.name,
            currentAssigneeId = item.currentAssigneeId?.toString(),
            lastAssigneeIds = item.lastAssigneeIds.map { it.toString() },
            serialNumber = item.serialNumber,
            note = item.note
        )

        is AssetUser -> NfcTaggableDto(
            id = item.id.toString(),
            name = item.name,
            tagType = TagType.AssetUser.name,
            tagStatus = item.tagStatus.name,
            currentAssigneeId = item.currentAssigneeId?.toString(),
            lastAssigneeIds = item.lastAssigneeIds.map { it.toString() },
            note = item.note
        )
    }
}

fun nfcTaggableDtoToDomain(dto: NfcTaggableDto): NfcTaggable {
    return when (TagType.valueOf(dto.tagType)) {
        TagType.Tool      -> dto.toToolDomain()
        TagType.Vehicle   -> dto.toVehicleDomain()
        TagType.Key       -> dto.toKeyRingDomain()
        TagType.AssetUser -> dto.toAssetUserDomain()
    }
}
