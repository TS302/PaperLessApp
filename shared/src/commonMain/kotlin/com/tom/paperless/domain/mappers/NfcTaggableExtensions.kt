package com.tom.paperless.domain.mappers

import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.KeyRing
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.Tool
import com.tom.paperless.domain.models.Vehicle
import com.tom.paperless.domain.models.enums.TagStatus

fun NfcTaggable.withName(name: String): NfcTaggable = when (this) {
    is Vehicle -> copy(name = name)
    is Tool -> copy(name = name)
    is KeyRing -> copy(name = name)
    is Employee -> copy(name = name)
    else -> this
}

fun NfcTaggable.withStatus(status: TagStatus): NfcTaggable = when (this) {
    is Vehicle -> copy(tagStatus = status)
    is Tool    -> copy(tagStatus = status)
    is KeyRing -> copy(tagStatus = status)
    is Employee -> copy(tagStatus = status)
    else -> this
}