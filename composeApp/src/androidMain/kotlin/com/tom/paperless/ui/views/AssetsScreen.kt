package com.tom.paperless.ui.views

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import com.tom.paperless.components.ItemsTopBar
import com.tom.paperless.ui.viewModels.AssetsViewModel
import org.koin.compose.koinInject

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ItemsScreen(
    assetsViewModel: AssetsViewModel = koinInject()
) {
    val uiStateFlow = assetsViewModel.uiState

    var showAddVehicleSheet by rememberSaveable { mutableStateOf(false) }

    Scaffold(
        topBar = {
            ItemsTopBar(
                titleText = "Objekte",
                onAddVehicleClick = { showAddVehicleSheet = true },
                onAddToolClick = { /* TODO: später */ },
                onAddKeyClick = { /* TODO: später */ }
            )
        }
    ) { paddingValues ->
        ItemsView(
            uiStateFlow = uiStateFlow,
            modifier = Modifier.padding(paddingValues),
            onItemClick = { /* TODO */ },
            onItemMenuClick = { /* TODO */ }
        )
    }
    if (showAddVehicleSheet) {
        AddVehicleSheet(
            onDismiss = {
                showAddVehicleSheet = false
            },
            onSaved = {
                assetsViewModel.reloadAssets()
            }
        )
    }
}
