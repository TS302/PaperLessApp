package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlin.uuid.Uuid

object EmployeeRepositoryImpl : EmployeeRepository {

    private val state = MutableStateFlow(initialEmployees())

    override fun getAllFlow(): Flow<List<Employee>> = state.asStateFlow()

    override suspend fun getAll(): List<Employee> = state.value

    override suspend fun getById(id: Uuid): Employee? =
        state.value.firstOrNull { it.id == id }

    override suspend fun add(employee: Employee): Employee {
        state.update { it + employee }
        return employee
    }

    override suspend fun update(employee: Employee): Employee? {
        var saved: Employee? = null
        state.update { current ->
            val index = current.indexOfFirst { it.id == employee.id }
            if (index >= 0) current.toMutableList().apply {
                this[index] = employee
                saved = employee
            } else current
        }
        return saved
    }

    override suspend fun delete(id: Uuid): Boolean {
        var removed = false
        state.update { cur ->
            val next = cur.filterNot { it.id == id }
            removed = next.size != cur.size
            next
        }
        return removed
    }

    private fun initialEmployees(): List<Employee> = listOf(
        Employee(Uuid.random(), "Clara Becker", "clara.becker@example.com", "+49 151 0000003", TargetType.Employee, TagStatus.available),
        Employee(Uuid.random(), "David Wagner", "david.wagner@example.com", "+49 151 0000004", TargetType.Employee, TagStatus.available),
        Employee(Uuid.random(), "Elena Schulz", "elena.schulz@example.com", "+49 151 0000005", TargetType.Employee, TagStatus.available),
        Employee(Uuid.random(), "Felix Hoffmann", "felix.hoffmann@example.com", "+49 151 0000006", TargetType.Employee, TagStatus.available),
        Employee(Uuid.random(), "Greta Klein", "greta.klein@example.com", "+49 151 0000007", TargetType.Employee, TagStatus.available),
        Employee(Uuid.random(), "Hannah Vogel", "hannah.vogel@example.com", "+49 151 0000008", TargetType.Employee, TagStatus.available),
        Employee(Uuid.random(), "Jonas Krause", "jonas.krause@example.com", "+49 151 0000009", TargetType.Employee, TagStatus.available),
        Employee(Uuid.random(), "Laura Neumann", "laura.neumann@example.com", "+49 151 0000010", TargetType.Employee, TagStatus.available),
    )
}