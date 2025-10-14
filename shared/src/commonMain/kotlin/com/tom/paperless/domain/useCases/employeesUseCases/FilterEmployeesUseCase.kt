package com.tom.paperless.domain.useCases.employeesUseCases

import com.tom.paperless.domain.models.Employee

class FilterEmployeesUseCase {
    operator fun invoke(
        all: List<Employee>,
        searchQueryText: String
    ): List<Employee> {
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