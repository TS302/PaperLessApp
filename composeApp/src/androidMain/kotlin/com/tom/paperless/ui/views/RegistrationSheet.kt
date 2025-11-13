package com.tom.paperless.ui.views

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.tom.paperless.theme.appPrimary
import com.tom.paperless.theme.appSecondary
import com.tom.paperless.components.SecureTextFieldInput
import com.tom.paperless.components.TextFieldInput
import com.tom.paperless.theme.error

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RegistrationSheet(
    isVisible: Boolean,
    onDismissRequest: () -> Unit,
    onRegister: (emailAddress: String, passwordPlaintext: String) -> Unit,
    isBusy: Boolean,
    visibleErrorMessage: String?
) {
    if (!isVisible) return

    ModalBottomSheet(onDismissRequest = onDismissRequest) {
        var firstName by remember { mutableStateOf("") }
        var lastName by remember { mutableStateOf("") }
        var emailAddress by remember { mutableStateOf("") }
        var passwordPlaintext by remember { mutableStateOf("") }
        var confirmPasswordPlaintext by remember { mutableStateOf("") }
        var isPasswordVisible by remember { mutableStateOf(false) }

        Column(
            modifier = Modifier
                .padding(horizontal = 24.dp, vertical = 16.dp)
                .fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text("REGISTRIEREN", style = MaterialTheme.typography.headlineLarge)
            Text(
                "KONTO ANLEGEN UND STARTEN",
                style = MaterialTheme.typography.labelSmall,
                color = Color.Black.copy(alpha = 0.8f)
            )

//            TextFieldInput("Vorname", firstName) { firstName = it }
//            TextFieldInput("Nachname", lastName) { lastName = it }
            TextFieldInput("E-Mail", emailAddress) { emailAddress = it }

            SecureTextFieldInput(
                fieldLabel = "Passwort",
                fieldValue = passwordPlaintext,
                onFieldValueChange = { passwordPlaintext = it },
                isPasswordVisible = isPasswordVisible,
                onTogglePasswordVisibility = { isPasswordVisible = !isPasswordVisible },
                showEyeIcon = true
            )
            SecureTextFieldInput(
                fieldLabel = "Passwort bestätigen",
                fieldValue = confirmPasswordPlaintext,
                onFieldValueChange = { confirmPasswordPlaintext = it },
                isPasswordVisible = isPasswordVisible,
                onTogglePasswordVisibility = { isPasswordVisible = !isPasswordVisible },
                showEyeIcon = true
            )

            val doPasswordsMatch = passwordPlaintext.isNotBlank() &&
                    confirmPasswordPlaintext.isNotBlank() &&
                    passwordPlaintext == confirmPasswordPlaintext

            Text(
                "Passwörter stimmen nicht überein.",
                color = Color.error,
                style = MaterialTheme.typography.bodySmall,
                modifier = Modifier
                    .padding(horizontal = 4.dp)
                    .height(if (doPasswordsMatch || confirmPasswordPlaintext.isBlank()) 0.dp else 18.dp)
            )

            Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
                TextButton(onClick = onDismissRequest) {
                    Text("Abbrechen", color = Color.appPrimary)
                }
                Spacer(Modifier.weight(1f))
                Button(
                    enabled = !isBusy,
                    onClick = {
                        if (doPasswordsMatch) {
                            onRegister(emailAddress.trim(), passwordPlaintext)
                        }
                    }
                ) {
                    Text(if (isBusy) "Erstellen…" else "Konto erstellen", color = Color.appSecondary)
                }
            }

            if (!visibleErrorMessage.isNullOrBlank()) {
                Text(visibleErrorMessage, color = Color.error, style = MaterialTheme.typography.bodySmall)
            }

            Spacer(Modifier.height(8.dp))
        }
    }
}