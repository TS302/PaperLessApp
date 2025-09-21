package com.tom.paperless.domain.models

import kotlin.uuid.Uuid

data class KeyRing(
    override val id: Uuid,
    override val name: String
) : NfcTaggable {
    override val targetType = TargetType.KEY
}