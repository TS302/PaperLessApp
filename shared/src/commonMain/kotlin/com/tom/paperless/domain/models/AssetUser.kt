package com.tom.paperless.domain.models

import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlin.uuid.Uuid

data class AssetUser(
    override val id: Uuid,
    override val name: String,
    val email: String,
    val phoneNumber: String,
    override val tagType: TagType = TagType.AssetUser,
    override val tagStatus: TagStatus = TagStatus.available,
    override val currentAssigneeId: Uuid? = null,
    override val lastAssigneeIds: List<Uuid> = emptyList(),
    override val note: String? = null
) : NfcTaggable {

    fun searchQuery(query: String): Boolean {
        val trimmed = query.trim()
        if (trimmed.isEmpty()) return true

        val query = trimmed.lowercase()
        return name.lowercase().contains(query) ||
                email.lowercase().contains(query)
    }
}