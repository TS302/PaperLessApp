package com.tom.paperless.data.repositories.dto

import kotlinx.serialization.Serializable
import kotlin.uuid.Uuid
import kotlinx.datetime.Instant

@Serializable
data class AssignmentDto(
    val id: String = "",
    val assetUserId: String = "",
    val tagId: String = "",
    val from: String = "",
    val until: String? = null,
    val note: String? = null
) {

    companion object {
        fun create(
            id: String,
            tagId: Uuid,
            assetUserId: Uuid,
            from: Instant,
            until: Instant? = null,
            note: String? = null
        ): AssignmentDto {
            return AssignmentDto(
                id = id,
                assetUserId = assetUserId.toString(),
                tagId = tagId.toString(),
                from = from.toString(),
                until = until?.toString(),
                note = note
            )
        }
    }
}