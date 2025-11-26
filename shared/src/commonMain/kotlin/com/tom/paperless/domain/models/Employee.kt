package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import kotlin.uuid.Uuid

data class Employee(
    override val id: Uuid,
    override val name: String,
    val email: String,
    val phoneNumber: String,
    override val targetType: TargetType = TargetType.Employee,
    override val tagStatus: TagStatus = TagStatus.available,
    override val currentAssigneeId: Uuid? = null,
    override val lastAssigneeIds: List<Uuid> = emptyList(),
    override val note: String? = null
) : NfcTaggable