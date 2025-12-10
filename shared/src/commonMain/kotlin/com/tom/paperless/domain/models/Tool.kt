package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

data class Tool(
    override val id: Uuid,
    override val name: String,
    override val tagType: TagType = TagType.Tool,
    override val tagStatus: TagStatus = TagStatus.available,
    override val currentAssigneeId: Uuid? = null,
    override val lastAssigneeIds: List<Uuid> = emptyList(),
    val brand: String? = "",
    val serialNumber: String? = "",
    override val note: String? = null
) : NfcTaggable