package com.tom.paperless.data.repositories.mappers

import com.tom.paperless.data.repositories.dto.ToolDto
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

fun Tool.toDto() = ToolDto(
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

fun ToolDto.toDomain() = Tool(
    id = Uuid.parse(id),
    name = name,
    tagType = TagType.valueOf(tagType),
    tagStatus = TagStatus.valueOf(tagStatus),
    currentAssigneeId = currentAssigneeId?.let { Uuid.parse(it) },
    lastAssigneeIds = lastAssigneeIds.map { Uuid.parse(it) },
    brand = brand,
    serialNumber = serialNumber,
    note = note
)
