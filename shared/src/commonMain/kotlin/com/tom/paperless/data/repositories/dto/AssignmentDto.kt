package com.tom.paperless.data.repositories.dto

import kotlinx.serialization.Serializable

@Serializable
data class AssignmentDto(
    val id: String = "",
    val assetUserId: String = "",
    val tagId: String = "",
    val from: String = "",
    val until: String? = null,
    val note: String? = null
)
