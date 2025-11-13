package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import kotlin.uuid.Uuid

data class Tool(
    override val id: Uuid,
    override val name: String,
    val serialNumber: String?,
    override val targetType: TargetType = TargetType.Tool,
    override val tagStatus: TagStatus
) : NfcTaggable