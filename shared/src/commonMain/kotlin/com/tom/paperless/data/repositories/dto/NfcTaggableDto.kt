package com.tom.paperless.data.repositories.dto

import kotlinx.serialization.Serializable

@Serializable
data class NfcTaggableDto(
    val id: String = "",
    val name: String = "",
    val tagType: String = "",
    val tagStatus: String = "",
    val currentAssigneeId: String? = null,
    val lastAssigneeIds: List<String> = emptyList(),
    val brand: String? = null,
    val serialNumber: String? = null,
    val plate: String? = null,
    val note: String? = null
)
