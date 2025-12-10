package com.tom.paperless.ui.views

import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Group
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp
import com.tom.paperless.components.EmployeesTopBar
import com.tom.paperless.components.ItemsTopBar
import com.tom.paperless.di.KoinStarter


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainTabView(
    onLogout: () -> Unit,
    onAddVehicleClick: () -> Unit = {},
    onAddToolClick: () -> Unit = {},
    onAddKeyClick: () -> Unit = {}
) {
    var selectedTabIndex by remember { mutableIntStateOf(0) }
    var showAddVehicleSheet by remember { mutableStateOf(false) }

    val companyViewModel = remember { KoinStarter.companyViewModel() }
    val tabs = remember {
        listOf(
            TabItem("Items", Icons.Filled.Inventory2),
            TabItem("Asset-User", Icons.Filled.Group),
            TabItem("Einstellungen", Icons.Filled.Settings),
        )
    }

    Scaffold(
        topBar = {
            when (selectedTabIndex) {
                0 -> ItemsTopBar(
                    titleText = "Assets",
                    onAddVehicleClick = { showAddVehicleSheet = true },
                    onAddToolClick = onAddToolClick,
                    onAddKeyClick = onAddKeyClick
                )
                1 -> EmployeesTopBar(
                    titleText = "Asset-User",
                    onAddEmployeeClick = onAddKeyClick
                )
                2 -> ItemsTopBar(
                    titleText = "Firma",
                    onAddVehicleClick = onAddVehicleClick,
                    onAddToolClick = onAddToolClick,
                    onAddKeyClick = onAddKeyClick
                )
            }
        },
        bottomBar = {
            NavigationBar(
                containerColor = MaterialTheme.colorScheme.surface,
                contentColor   = MaterialTheme.colorScheme.onSurface,
                tonalElevation = 0.dp
            ) {
                tabs.forEachIndexed { tabIndex, tab ->
                    NavigationBarItem(
                        selected = tabIndex == selectedTabIndex,
                        onClick = { selectedTabIndex = tabIndex },
                        icon = { Icon(tab.icon, contentDescription = tab.title) },
                        label = { Text(tab.title) },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = MaterialTheme.colorScheme.primary,
                            selectedTextColor = MaterialTheme.colorScheme.primary,
                            unselectedIconColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.60f),
                            unselectedTextColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.60f),
                            indicatorColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f),
                        )
                    )
                }
            }
        }
    ) { innerPadding ->
        when (selectedTabIndex) {
            0 -> ItemsView(
                uiStateFlow = companyViewModel.uiState,
                modifier = Modifier
                    .padding(innerPadding)
                    .consumeWindowInsets(innerPadding)
            )
            1 -> EmployeesView(
                modifier = Modifier
                    .padding(innerPadding)
                    .consumeWindowInsets(innerPadding)
            )
            2 -> SettingsView(
                onLogout = onLogout,
                modifier = Modifier
                    .padding(innerPadding)
                    .consumeWindowInsets(innerPadding)
            )
        }
    }
    if (showAddVehicleSheet) {
        AddVehicleSheet(
            onDismiss = {
                showAddVehicleSheet = false
            }
        )
    }
}

private data class TabItem(val title: String, val icon: ImageVector)