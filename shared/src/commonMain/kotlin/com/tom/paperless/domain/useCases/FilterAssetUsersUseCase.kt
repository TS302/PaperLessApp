package com.tom.paperless.domain.useCases

import com.tom.paperless.domain.models.AssetUser

class FilterAssetUsersUseCase {
    operator fun invoke(
        all: List<AssetUser>,
        searchQueryText: String
    ): List<AssetUser> {
        val querry = searchQueryText.trim().lowercase()
        if (querry.isBlank()) {
            return all.sortedBy { it.name.lowercase() }
        }

        return all.filter { employee ->
            val name = employee.name.lowercase()
            val email = (employee.email ?: "").lowercase()
            val phone = (employee.phoneNumber ?: "").lowercase()
            name.contains(querry) || email.contains(querry) || phone.contains(querry)
        }.sortedBy { it.name.lowercase() }
    }
}