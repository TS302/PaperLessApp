package com.tom.paperless.domain.models.enums

enum class TagStatus(
    val displayName: String,
    val caseName: String,
    val caseColor: String
) {
    available(
        displayName = "Verfügbar",
        caseName = "AVAILABLE",
        caseColor = "#4CAF50" // Grün
    ),
    inUse(
        displayName = "im Einsatz",
        caseName = "IN_USE",
        caseColor = "#FF9800" // Orange
    ),
    passive(
        displayName = "Passiv",
        caseName = "PASSIVE",
        caseColor = "#9E9E9E" // Grau
    )
}