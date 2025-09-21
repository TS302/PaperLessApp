package com.tom.paperless.domain.models

import kotlin.uuid.Uuid

data class TagBinding(
    val tagId: Uuid,
    val targetType: TargetType,
    val targetId: Uuid
)