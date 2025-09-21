package com.tom.paperless.domain.models

import kotlin.uuid.Uuid

data class Vehicle(
    override val id: Uuid,
    override val name: String,
    val plate: String
) : NfcTaggable {
    override val targetType = TargetType.VEHICLE
}