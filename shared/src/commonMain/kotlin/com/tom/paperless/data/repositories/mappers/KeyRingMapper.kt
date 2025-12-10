package com.tom.paperless.data.repositories.mappers

import com.tom.paperless.data.repositories.dto.KeyRingDto
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

fun KeyRing.toDto() = KeyRingDto(
    id = id.toString(),
    name = name,
    serialNumber = serialNumber,
    tagType = tagType.name,
    tagStatus = tagStatus.name,
    currentAssigneeId = currentAssigneeId?.toString(),
    lastAssigneeIds = lastAssigneeIds.map { it.toString() },
    note = note
)

fun KeyRingDto.toDomain() = KeyRing(
    id = Uuid.parse(id),
    name = name,
    serialNumber = serialNumber,
    tagType = TagType.valueOf(tagType),
    tagStatus = TagStatus.valueOf(tagStatus),
    currentAssigneeId = currentAssigneeId?.let { Uuid.parse(it) },
    lastAssigneeIds = lastAssigneeIds.map { Uuid.parse(it) },
    note = note
)
