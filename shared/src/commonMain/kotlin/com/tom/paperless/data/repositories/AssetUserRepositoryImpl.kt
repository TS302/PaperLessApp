package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.AssetUser
import com.tom.paperless.domain.models.enums.TagStatus
import com.tom.paperless.domain.models.enums.TagType
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlin.uuid.Uuid

object AssetUserRepositoryImpl : AssetUserRepository {

    private val state = MutableStateFlow(initialAssetUsers())

    override fun observeAll(): Flow<List<AssetUser>> = state.asStateFlow()

    override suspend fun getAll(): List<AssetUser> = state.value

    override suspend fun getById(id: Uuid): AssetUser? =
        state.value.firstOrNull { it.id == id }

    override suspend fun add(assetUser: AssetUser): AssetUser {
        state.update { it + assetUser }
        return assetUser
    }

    override suspend fun update(assetUser: AssetUser): AssetUser? {
        var saved: AssetUser? = null
        state.update { current ->
            val index = current.indexOfFirst { it.id == assetUser.id }
            if (index >= 0) current.toMutableList().apply {
                this[index] = assetUser
                saved = assetUser
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

    private fun initialAssetUsers(): List<AssetUser> = listOf(
        AssetUser(
            Uuid.random(),
            "Clara Becker",
            "clara.becker@example.com",
            "+49 151 0000003",
            TagType.AssetUser,
            TagStatus.available,
            currentAssigneeId = null,
            lastAssigneeIds = emptyList()
        ),
        AssetUser(
            Uuid.random(),
            "David Wagner",
            "david.wagner@example.com",
            "+49 151 0000004",
            TagType.AssetUser,
            TagStatus.available,
            currentAssigneeId = null,
            lastAssigneeIds = emptyList()
        ),
        AssetUser(
            Uuid.random(),
            "Elena Schulz",
            "elena.schulz@example.com",
            "+49 151 0000005",
            TagType.AssetUser,
            TagStatus.available,
            currentAssigneeId = null,
            lastAssigneeIds = emptyList()
        ),
        AssetUser(
            Uuid.random(),
            "Felix Hoffmann",
            "felix.hoffmann@example.com",
            "+49 151 0000006",
            TagType.AssetUser,
            TagStatus.available,
            currentAssigneeId = null,
            lastAssigneeIds = emptyList()
        ),
        AssetUser(
            Uuid.random(),
            "Greta Klein",
            "greta.klein@example.com",
            "+49 151 0000007",
            TagType.AssetUser,
            TagStatus.available,
            currentAssigneeId = null,
            lastAssigneeIds = emptyList()
        ),
        AssetUser(
            Uuid.random(),
            "Hannah Vogel",
            "hannah.vogel@example.com",
            "+49 151 0000008",
            TagType.AssetUser,
            TagStatus.available,
            currentAssigneeId = null,
            lastAssigneeIds = emptyList()
        ),
        AssetUser(
            Uuid.random(),
            "Jonas Krause",
            "jonas.krause@example.com",
            "+49 151 0000009",
            TagType.AssetUser,
            TagStatus.available,
            currentAssigneeId = null,
            lastAssigneeIds = emptyList()
        ),
        AssetUser(
            Uuid.random(),
            "Laura Neumann",
            "laura.neumann@example.com",
            "+49 151 0000010",
            TagType.AssetUser,
            TagStatus.available,
            currentAssigneeId = null,
            lastAssigneeIds = emptyList()
        ),
    )
}