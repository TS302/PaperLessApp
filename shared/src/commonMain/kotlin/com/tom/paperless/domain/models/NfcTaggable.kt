package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

sealed interface NfcTaggable {
    val id: Uuid
    val name: String
    val tagType: TagType
    val tagStatus: TagStatus
    val currentAssigneeId: Uuid?
    val lastAssigneeIds: List<Uuid>
    val note: String?
}