package com.tom.paperless.components

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ItemsTopBar(
    titleText: String,
    onAddVehicleClick: () -> Unit,
    onAddToolClick: () -> Unit,
    onAddKeyClick: () -> Unit
) {
    var isAddMenuExpanded by remember { mutableStateOf(false) }

    Surface(
        color = MaterialTheme.colorScheme.surface,
        contentColor = MaterialTheme.colorScheme.onSurface,
        tonalElevation = 0.dp
    ) {
        TopAppBar(
            title = {
                Text(
                    text = titleText,
                    color = MaterialTheme.colorScheme.primary
                )
            },
            actions = {
                IconButton(onClick = { isAddMenuExpanded = true }) {
                    Icon(
                        imageVector = Icons.Filled.Add,
                        contentDescription = "Objekt hinzufügen",
                        tint = MaterialTheme.colorScheme.primary
                    )
                }
                DropdownMenu(
                    expanded = isAddMenuExpanded,
                    onDismissRequest = { isAddMenuExpanded = false },
                    containerColor = MaterialTheme.colorScheme.surface
                ) {
                    DropdownMenuItem(
                        text = {
                            Text("Fahrzeug hinzufügen", color = MaterialTheme.colorScheme.primary)
                        },
                        onClick = {
                            isAddMenuExpanded = false
                            onAddVehicleClick()
                        }
                    )
                    DropdownMenuItem(
                        text = {
                            Text(
                                "Werkzeug hinzufügen",
                                color = MaterialTheme.colorScheme.primary
                            )
                        },
                        onClick = {
                            isAddMenuExpanded = false
                            onAddToolClick()
                        }
                    )
                    DropdownMenuItem(
                        text = {
                            Text(
                                "Schlüssel hinzufügen",
                                color = MaterialTheme.colorScheme.primary
                            )
                        },
                        onClick = {
                            isAddMenuExpanded = false
                            onAddKeyClick()
                        }
                    )
                }
            }
        )
    }
}