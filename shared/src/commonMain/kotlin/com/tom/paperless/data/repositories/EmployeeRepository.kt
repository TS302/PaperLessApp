package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Employee
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.Uuid

interface EmployeeRepository {
    fun observeAll(): StateFlow<List<Employee>>
    suspend fun getAll(): List<Employee>
    suspend fun getById(id: Uuid): Employee?
    suspend fun add(employee: Employee): Employee
    suspend fun update(employee: Employee): Employee?
    suspend fun delete(id: Uuid): Boolean
}