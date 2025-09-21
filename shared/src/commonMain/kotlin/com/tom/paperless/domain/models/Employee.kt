package com.tom.paperless.domain.models

import kotlin.uuid.Uuid

data class Employee(
    override val id: kotlin.uuid.Uuid,
    override val name: String,
    val email: String,
    val phoneNumber: String
) : NfcTaggable {
    override val targetType = TargetType.EMPLOYEE
}