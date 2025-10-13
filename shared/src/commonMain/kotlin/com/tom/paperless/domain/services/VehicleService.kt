package com.tom.paperless.domain.services

import com.tom.paperless.domain.models.Vehicle
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.Uuid

interface VehicleService {
    fun observeVehicles(): StateFlow<List<Vehicle>>
    suspend fun getVehicles(): List<Vehicle>
    suspend fun updatePlate(id: Uuid, plate: String): Vehicle
}