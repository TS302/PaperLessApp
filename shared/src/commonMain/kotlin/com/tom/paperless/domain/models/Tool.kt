package com.tom.paperless.domain.models

import kotlin.uuid.Uuid

data class Tool(
    override val id: Uuid,
    override val name: String,
    val serialNumber: String?
) : NfcTaggable {
    override val targetType = TargetType.TOOL
}