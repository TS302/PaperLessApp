package com.tom.paperless.components

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.Button
import androidx.compose.material3.Divider
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EmployeesTopBar(
    titleText: String,
    onAddEmployeeClick: () -> Unit,
) {
    // Steuert das Sheet
    var showAddEmployeeSheet by remember { mutableStateOf(false) }
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)

    // Der eigentliche TopAppBar
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
                IconButton(
                    onClick = {
                        showAddEmployeeSheet = true
                        onAddEmployeeClick()
                    }
                ) {
                    Icon(
                        imageVector = Icons.Filled.Add,
                        contentDescription = "Mitarbeiter hinzufügen",
                        tint = MaterialTheme.colorScheme.primary
                    )
                }
            }
        )
    }

    // Das Bottom Sheet (wird nur angezeigt, wenn showAddEmployeeSheet = true)
    if (showAddEmployeeSheet) {
        ModalBottomSheet(
            onDismissRequest = { showAddEmployeeSheet = false },
            sheetState = sheetState
        ) {
            // >>> Inhalt deines Sheets – hier kannst du beliebig erweitern
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 16.dp)
            ) {
                Text(
                    text = "Neuen Mitarbeiter hinzufügen",
                    style = MaterialTheme.typography.titleMedium
                )
                Spacer(Modifier.height(8.dp))
                Text(
                    text = "Hier könntest du ein Formular, Quick-Actions oder Filter einbauen."
                )

                Spacer(Modifier.height(16.dp))
                Divider()
                Spacer(Modifier.height(16.dp))

                Row(
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Button(
                        onClick = {
                            // TODO: Aktion ausführen (z. B. Navigation zu AddEmployeeScreen)
                            showAddEmployeeSheet = false
                        }
                    ) {
                        Text("Jetzt anlegen")
                    }
                    Button(
                        onClick = { showAddEmployeeSheet = false }
                    ) {
                        Text("Abbrechen")
                    }
                }
                Spacer(Modifier.height(8.dp))
            }
        }
    }
}