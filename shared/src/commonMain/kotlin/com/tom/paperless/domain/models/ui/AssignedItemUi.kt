package com.tom.paperless.domain.models.ui

import com.tom.paperless.domain.models.enums.TagStatus
import kotlin.time.Clock
import kotlin.time.ExperimentalTime
import kotlin.time.Instant

data class AssignedItemUi @OptIn(ExperimentalTime::class) constructor(
    val id: String,
    val employeeName: String? = null,
    val from: Instant = Clock.System.now(),
    val until: Instant? = null,
    val displayName: String,
    val type: String,
    val subtype: String? = null,
    val code: String? = null,
    val statusText: String? = null,
    val status: TagStatus? = null,
    val iconName: String? = null
)