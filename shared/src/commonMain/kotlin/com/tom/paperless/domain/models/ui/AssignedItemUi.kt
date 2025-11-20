package com.tom.paperless.domain.models.ui

import com.tom.paperless.domain.models.enums.TagStatus

data class AssignedItemUi(
    val id: String,
    val displayName: String,
    val type: String,            // "vehicle" | "tool" | "key" | "other"
    val subtype: String? = null,
    val code: String? = null,    // z.B. Kennzeichen / Inventarnummer
    val statusText: String? = null,
    val status: TagStatus? = null,
    val iconName: String? = null // Optional: direkter SF Symbol Name
)