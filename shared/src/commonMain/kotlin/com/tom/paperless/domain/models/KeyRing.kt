package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

data class KeyRing(
    override val id: Uuid,
    override val name: String,
    val serialNumber: String? = null,
    override val tagType: TagType = TagType.Key,
    override val tagStatus: TagStatus = TagStatus.available,
    override val currentAssigneeId: Uuid? = null,
    override val lastAssigneeIds: List<Uuid> = emptyList(),
    override val note: String? = null
) : NfcTaggable