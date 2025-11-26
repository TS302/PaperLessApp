package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import kotlin.uuid.Uuid

interface NfcTaggable {
    val id: Uuid
    val name: String
    val targetType: TargetType
    val tagStatus: TagStatus
    val currentAssigneeId: Uuid?
    val lastAssigneeIds: List<Uuid>
    val note: String?
}