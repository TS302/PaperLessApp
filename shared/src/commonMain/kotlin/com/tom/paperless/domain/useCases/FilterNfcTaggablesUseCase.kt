package com.tom.paperless.domain.useCases

import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagType

class FilterNfcTaggablesUseCase {
    operator fun invoke(
        allItems: List<NfcTaggable>,
        typeFilter: TagType?,
        searchQueryText: String
    ): List<NfcTaggable> {
        val byType = typeFilter?.let { selectedType ->
            allItems.filter { it.tagType == selectedType }
        } ?: allItems

        if (searchQueryText.isBlank()) {
            return byType.sortedBy { it.name.lowercase() }
        }

        val query = searchQueryText.trim().lowercase()
        return byType.filter { item ->
            val name = item.name.lowercase()
            name.contains(query)
        }.sortedBy { it.name.lowercase() }
    }
}