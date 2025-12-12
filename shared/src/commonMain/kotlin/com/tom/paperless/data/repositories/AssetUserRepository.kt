package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.AssetUser
import kotlinx.coroutines.flow.Flow
import kotlin.uuid.Uuid

interface AssetUserRepository {

    suspend fun add(assetUser: AssetUser): AssetUser

    suspend fun getAll(): List<AssetUser>

    suspend fun getById(id: Uuid): AssetUser?

    suspend fun update(assetUser: AssetUser): AssetUser

    suspend fun delete(id: Uuid): Boolean
}