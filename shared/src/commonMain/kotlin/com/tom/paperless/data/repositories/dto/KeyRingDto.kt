package com.tom.paperless.data.repositories.dto

import kotlinx.serialization.Serializable

@Serializable
data class KeyRingDto(
    val id: String = "",
    val name: String = "",
    val serialNumber: String? = "",
    val tagType: String = "",
    val tagStatus: String = "",
    val currentAssigneeId: String? = null,
    val lastAssigneeIds: List<String> = emptyList(),
    val note: String? = null
)