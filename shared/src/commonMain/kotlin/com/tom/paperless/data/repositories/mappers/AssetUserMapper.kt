package com.tom.paperless.data.repositories.mappers

import com.tom.paperless.data.repositories.dto.AssetUserDto
import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

fun AssetUser.toDto() = AssetUserDto(
    id = id.toString(),
    name = name,
    email = email,
    phoneNumber = phoneNumber,
    tagType = tagType.name,
    tagStatus = tagStatus.name,
    currentAssigneeId = currentAssigneeId?.toString(),
    lastAssigneeIds = lastAssigneeIds.map { it.toString() },
    note = note
)

fun AssetUserDto.toDomain() = AssetUser(
    id = Uuid.parse(id),
    name = name,
    email = email,
    phoneNumber = phoneNumber,
    tagType = TagType.valueOf(tagType),
    tagStatus = TagStatus.valueOf(tagStatus),
    currentAssigneeId = currentAssigneeId?.let { Uuid.parse(it) },
    lastAssigneeIds = lastAssigneeIds.map { Uuid.parse(it) },
    note = note
)
