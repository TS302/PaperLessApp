package com.tom.paperless.domain.models

import kotlin.uuid.Uuid

interface NfcTaggable {
    val id: Uuid
    val name: String
    val targetType: TargetType
}