package com.tom.paperless.data.repositories.dto

import kotlinx.serialization.Serializable

@Serializable
data class ToolDto(
    val id: String = "",
    val name: String = "",
    val tagType: String = "",
    val tagStatus: String = "",
    val currentAssigneeId: String? = null,
    val lastAssigneeIds: List<String> = emptyList(),
    val brand: String? = "",
    val serialNumber: String? = "",
    val note: String? = null
)