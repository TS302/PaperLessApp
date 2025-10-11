package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Employee
import kotlinx.coroutines.flow.Flow
import kotlin.uuid.Uuid

interface EmployeeRepository {

    fun getAllFlow(): Flow<List<Employee>>

    suspend fun getAll(): List<Employee>
    suspend fun getById(id: Uuid): Employee?
    suspend fun add(employee: Employee): Employee
    suspend fun update(employee: Employee): Employee?
    suspend fun delete(id: Uuid): Boolean
}