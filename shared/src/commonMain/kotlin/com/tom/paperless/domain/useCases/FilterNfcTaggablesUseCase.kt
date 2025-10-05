package com.tom.paperless.domain.useCases

import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TargetType

class FilterNfcTaggablesUseCase {
    operator fun invoke(
        allItems: List<NfcTaggable>,
        typeFilter: TargetType?,
        searchQueryText: String
    ): List<NfcTaggable> {
        val byType = typeFilter?.let { t -> allItems.filter { it.targetType == t } } ?: allItems
        if (searchQueryText.isBlank()) return byType

        val q = searchQueryText.trim().lowercase()
        return byType.filter { item ->
            val name = item.name.lowercase()
            // Hier ggf. weitere Felder einbeziehen (z. B. plate, serialNumber)
            name.contains(q)
        }
    }
}