package com.tom.paperless.domain.models

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlin.uuid.Uuid

data class Assignment(
    val id: Uuid,
    val assetUserId: Uuid,
    val tagId: Uuid,
    val from: Instant = Clock.System.now(),
    val until: Instant? = null,
    val note: String? = null
)
