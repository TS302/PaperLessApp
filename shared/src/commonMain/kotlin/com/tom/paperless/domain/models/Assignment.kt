package com.tom.paperless.domain.models

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlin.uuid.Uuid

data class Assignment(
    val id: Uuid,
    val employeeId: Uuid,
    val taggableId: Uuid,
    val from: Instant = Clock.System.now(),
    val until: Instant? = null
)
