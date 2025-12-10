package com.tom.paperless.ui.views

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import com.tom.paperless.ui.viewModels.AddVehicleViewModel
import kotlinx.coroutines.launch
import org.koin.compose.koinInject

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddVehicleSheet(
    viewModel: AddVehicleViewModel = koinInject(),
    onDismiss: () -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()
    val canSave = uiState.name.trim().isNotEmpty() && !uiState.isSaving

    LaunchedEffect(uiState.didSave) {
        if (uiState.didSave) {
            onDismiss()
            viewModel.resetDidSave()
        }
    }
    ModalBottomSheet(
        onDismissRequest = onDismiss
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .navigationBarsPadding()
                .imePadding()
                .padding(horizontal = 16.dp, vertical = 12.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text("Fahrzeug hinzufügen", style = MaterialTheme.typography.titleLarge)

            OutlinedTextField(
                value = uiState.name,
                onValueChange = { value -> viewModel.setName(value) },
                label = { Text(text = "Name des Fahrzeugs *") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next)
            )

            OutlinedTextField(
                value = uiState.plate,
                onValueChange = { value -> viewModel.setPlate(value) },
                label = { Text("Kennzeichen") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next)
            )

            OutlinedTextField(
                value = uiState.brand,
                onValueChange = { value -> viewModel.setBrand(value) },
                label = { Text("Marke / Hersteller") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next)
            )

//            OutlinedTextField(
//                value = uiState.note,
//                onValueChange = { value -> viewModel.setNote(value) },
//                label = { Text("Notiz (optional)") },
//                modifier = Modifier
//                    .fillMaxWidth()
//                    .heightIn(min = 80.dp),
//                maxLines = 4
//            )

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 8.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedButton(
                    onClick = onDismiss,
                    modifier = Modifier.weight(1f),
                    enabled = !uiState.isSaving
                ) { Text("Abbrechen") }

                Button(
                    onClick = {
                            viewModel.submit()
                    },
                    modifier = Modifier.weight(1f),
                    enabled = canSave
                ) {
                    if (uiState.isSaving) {
                        CircularProgressIndicator(
                            modifier = Modifier.size(18.dp),
                            strokeWidth = 2.dp
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Speichere…")
                    } else {
                        Text("Speichern")
                    }
                }
            }
        }
    }
}