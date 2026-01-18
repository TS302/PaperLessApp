package com.tom.paperless.helper

import kotlin.uuid.Uuid
import kotlin.uuid.ExperimentalUuidApi

@OptIn(ExperimentalUuidApi::class)
fun uuidFromString(value: String): Uuid = Uuid.parse(value)