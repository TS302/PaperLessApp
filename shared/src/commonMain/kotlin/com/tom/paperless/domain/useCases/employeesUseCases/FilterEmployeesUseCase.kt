package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.domain.models.Employee

class FilterEmployeesUseCase {
    operator fun invoke(
        all: List<Employee>,
        searchQueryText: String
    ): List<Employee> {
        val querry = searchQueryText.trim().lowercase()
        if (querry.isBlank()) return all
        return all.filter { e ->
            e.name.lowercase().contains(querry) ||
                    (e.email ?: "").lowercase().contains(querry) ||
                    (e.phoneNumber ?: "").lowercase().contains(querry)
        }
    }
}