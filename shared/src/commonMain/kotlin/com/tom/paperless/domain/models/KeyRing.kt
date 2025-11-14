package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import kotlin.uuid.Uuid

data class KeyRing(
    override val id: Uuid,
    override val name: String,
    override val targetType: TargetType = TargetType.Key,
    override val tagStatus: TagStatus = TagStatus.available,
    override val currentAssigneeId: Uuid? = null,
    override val lastAssigneeIds: List<Uuid> = emptyList()
) : NfcTaggable