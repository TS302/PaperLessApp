package com.tom.paperless.data.repositories.mappers

import com.tom.paperless.data.repositories.dto.AssignmentDto
import com.tom.paperless.domain.models.Assignment
import kotlinx.datetime.Instant
import kotlin.uuid.Uuid

fun Assignment.toDto() = AssignmentDto(
    id = id.toString(),
    assetUserId = assetUserId.toString(),
    tagId = tagId.toString(),
    from = from.toString(),
    until = until?.toString(),
    note = note
)

fun AssignmentDto.toDomain() = Assignment(
    id = Uuid.parse(id),
    assetUserId = Uuid.parse(assetUserId),
    tagId = Uuid.parse(tagId),
    from = Instant.parse(from),
    until = until?.let { Instant.parse(it) },
    note = note
)
