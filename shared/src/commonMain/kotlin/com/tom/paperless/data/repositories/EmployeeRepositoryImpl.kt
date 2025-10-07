package com.tom.paperless.data.repositories

import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.tom.paperless.domain.models.Employee
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TargetType
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.update
import kotlin.uuid.Uuid

object EmployeeRepositoryImpl : EmployeeRepository {
    private val _employees = MutableStateFlow<List<Employee>>(initialEmployees())
    override fun observeAll() = _employees
    override suspend fun getAll() = _employees.value
    override suspend fun getById(id: Uuid) = _employees.value.firstOrNull { it.id == id }
    override suspend fun add(employee: Employee): Employee { _employees.update { it + employee }; return employee }
    override suspend fun update(employee: Employee): Employee? {
        var saved: Employee? = null
        _employees.update { cur ->
            val idx = cur.indexOfFirst { it.id == employee.id }
            if (idx >= 0) cur.toMutableList().apply { set(idx, employee); saved = employee }
            else cur
        }
        return saved
    }
    override suspend fun delete(id: Uuid): Boolean {
        var removed = false
        _employees.update { cur -> cur.filterNot { it.id == id }.also { removed = it.size != cur.size } }
        return removed
    }

    private fun initialEmployees(): List<Employee> = listOf(
        Employee(
            id = Uuid.random(),
            name = "Clara Becker",
            email = "clara.becker@example.com",
            phoneNumber = "+49 151 0000003",
            tagStatus = com.tom.paperless.domain.models.enums.TagStatus.available
        ),
        Employee(
            id = Uuid.random(),
            name = "David Wagner",
            email = "david.wagner@example.com",
            phoneNumber = "+49 151 0000004",
            tagStatus = com.tom.paperless.domain.models.enums.TagStatus.inUse
        ),
        Employee(
            id = Uuid.random(),
            name = "Clara Becker",
            email = "clara.becker@example.com",
            phoneNumber = "+49 151 0000003",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "David Wagner",
            email = "david.wagner@example.com",
            phoneNumber = "+49 151 0000004",
            tagStatus = TagStatus.available,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Elena Schulz",
            email = "elena.schulz@example.com",
            phoneNumber = "+49 151 0000005",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Felix Hoffmann",
            email = "felix.hoffmann@example.com",
            phoneNumber = "+49 151 0000006",
            tagStatus = TagStatus.available,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Greta Klein",
            email = "greta.klein@example.com",
            phoneNumber = "+49 151 0000007",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Hannah Vogel",
            email = "hannah.vogel@example.com",
            phoneNumber = "+49 151 0000008",
            tagStatus = TagStatus.available,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Jonas Krause",
            email = "jonas.krause@example.com",
            phoneNumber = "+49 151 0000009",
            tagStatus = TagStatus.passive,
            targetType = TargetType.Employee
        ),
        Employee(
            id = Uuid.random(),
            name = "Laura Neumann",
            email = "laura.neumann@example.com",
            phoneNumber = "+49 151 0000010",
            tagStatus = TagStatus.inUse,
            targetType = TargetType.Employee
        )
    )
}