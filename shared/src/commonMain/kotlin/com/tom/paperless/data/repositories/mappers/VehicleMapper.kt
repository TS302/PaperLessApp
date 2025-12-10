package com.tom.paperless.data.repositories.mappers

import com.tom.paperless.data.repositories.dto.VehicleDto
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

fun Vehicle.toDto() = VehicleDto(
    id = id.toString(),
    name = name,
    plate = plate,
    brand = brand,
    tagType = tagType.name,
    tagStatus = tagStatus.name,
    currentAssigneeId = currentAssigneeId?.toString(),
    lastAssigneeIds = lastAssigneeIds.map { it.toString() },
    note = note
)

fun VehicleDto.toDomain() = Vehicle(
    id = Uuid.parse(id),
    name = name,
    plate = plate,
    brand = brand,
    tagType = TagType.valueOf(tagType),
    tagStatus = TagStatus.valueOf(tagStatus),
    currentAssigneeId = currentAssigneeId?.let { Uuid.parse(it) },
    lastAssigneeIds = lastAssigneeIds.map { Uuid.parse(it) },
    note = note
)
