package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import kotlin.uuid.Uuid

data class KeyRing(
    override val id: Uuid,
    override val name: String,
    override val targetType: TargetType = TargetType.Employee,
    override val tagStatus: TagStatus
) : NfcTaggable