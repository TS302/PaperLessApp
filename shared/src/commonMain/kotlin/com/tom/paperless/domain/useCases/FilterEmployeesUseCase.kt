package com.tom.paperless.domain.useCases

import com.tom.paperless.domain.models.Employee

class FilterEmployeesUseCase {
    operator fun invoke(
        all: List<Employee>,
        searchQueryText: String
    ): List<Employee> {
        val q = searchQueryText.trim().lowercase()
        if (q.isBlank()) return all
        return all.filter { e ->
            e.name.lowercase().contains(q) ||
                    e.email.lowercase().contains(q) ||
                    e.phoneNumber.lowercase().contains(q)
        }
    }
}