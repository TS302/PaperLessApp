//package com.tom.paperless.domain.useCases
//
//import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
//import com.tom.paperless.data.repositories.NfcTaggableRepository
//import com.tom.paperless.domain.models.NfcTaggable
//import com.tom.paperless.domain.models.enums.TargetType
//
//class GetNfcTaggablesFilteredUseCase(
//    private val repository: NfcTaggableRepository
//) {
//    @NativeCoroutines
//    suspend operator fun invoke(
//        typeFilter: TargetType?,
//        searchQueryText: String
//    ): List<NfcTaggable> {
//        val allItems = repository.getAll()
//
//        val itemsAfterTypeFilter = searchQueryText.trim().lowercase()
//        return allItems
//            .asSequence()
//            .filter { item -> typeFilter == null || item.targetType == typeFilter }
//            .filter { item -> itemsAfterTypeFilter.isBlank() || item.name.lowercase().contains(itemsAfterTypeFilter) }
//            .sortedBy { it.name.lowercase() }
//            .toList()
//    }
//}