package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

data class Vehicle(
    override val id: Uuid,
    override val name: String,
    override val tagType: TagType = TagType.Vehicle,
    override val tagStatus: TagStatus = TagStatus.available,
    override val currentAssigneeId: Uuid? = null,
    override val lastAssigneeIds: List<Uuid> = emptyList(),
    val plate: String? = "",
    val brand: String? = "",
    override val note: String? = null
) : NfcTaggable