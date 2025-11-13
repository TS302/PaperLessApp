//package com.tom.paperless.domain.services
//
//import com.tom.paperless.data.repositories.NfcTaggableRepository
//import com.tom.paperless.domain.models.Vehicle
//import com.tom.paperless.domain.models.enums.TargetType
//import kotlinx.coroutines.CoroutineScope
//import kotlinx.coroutines.Dispatchers
//import kotlinx.coroutines.SupervisorJob
//import kotlinx.coroutines.flow.SharingStarted
//import kotlinx.coroutines.flow.StateFlow
//import kotlinx.coroutines.flow.map
//import kotlinx.coroutines.flow.stateIn
//import kotlin.uuid.Uuid
//
//class VehicleServiceImpl(
//    private val repo: NfcTaggableRepository,
//    private val scope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
//) : VehicleService {
//
//    override fun observeVehicles(): StateFlow<List<Vehicle>> =
//        repo.observeByType(TargetType.Vehicle)
//            .map { it.filterIsInstance<Vehicle>() }
//            .stateIn(scope, SharingStarted.Eagerly, emptyList())
//
//    override suspend fun getVehicles(): List<Vehicle> =
//        repo.getAllByType(TargetType.Vehicle).filterIsInstance<Vehicle>()
//
//    override suspend fun updatePlate(id: Uuid, plate: String): Vehicle {
//        val current = repo.getById(id) as? Vehicle ?: error("Not a Vehicle: $id")
//        val updated = current.copy(plate = plate)
//        return repo.update(updated) as Vehicle
//    }
//}