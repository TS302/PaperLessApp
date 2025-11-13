package com.tom.paperless.ui.views


import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.tom.paperless.domain.models.*
import com.tom.paperless.domain.models.uiStates.NfcTaggablesUiState
import kotlinx.coroutines.flow.StateFlow
import kotlin.uuid.ExperimentalUuidApi

@OptIn(ExperimentalUuidApi::class)
@Composable
fun ItemsView(
    uiStateFlow: StateFlow<NfcTaggablesUiState>,
    modifier: Modifier = Modifier,
    onItemClick: (NfcTaggable) -> Unit = {},
    onItemMenuClick: (NfcTaggable) -> Unit = {}
) {
    val uiState by uiStateFlow.collectAsState()

    if (uiState.isLoading) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
        return
    }
    uiState.errorMessage?.let {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { Text(it, color = MaterialTheme.colorScheme.error) }
        return
    }

    LazyColumn(
        modifier = modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.surface),
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        items(uiState.items, key = { it.id.toString() }) { item ->
            val subtitle = when (item) {
                is Vehicle -> item.plate
                is Tool    -> item.serialNumber
                is KeyRing -> null
                else       -> null
            }
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(MaterialTheme.colorScheme.surfaceVariant, RoundedCornerShape(12.dp))
                    .clickable { onItemClick(item) }
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Filled.Inventory2, contentDescription = null, tint = MaterialTheme.colorScheme.primary)
                Spacer(Modifier.width(12.dp))
                Column(Modifier.weight(1f)) {
                    Text(item.name, style = MaterialTheme.typography.bodyLarge)
                    subtitle?.let {
                        Text(it, style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.8f))
                    }
                }
                IconButton(onClick = { onItemMenuClick(item) }) {
                    Icon(Icons.Filled.MoreVert, contentDescription = "Mehr")
                }
            }
        }
    }
}
