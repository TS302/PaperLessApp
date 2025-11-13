package com.tom.paperless.ui.views

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.tom.paperless.theme.appPrimary
import com.tom.paperless.components.SecureTextFieldInput
import com.tom.paperless.components.TextFieldInput
import com.tom.paperless.theme.error
import com.tom.paperless.theme.secondary

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoginView(
    onLogin: (emailAddress: String, passwordPlaintext: String) -> Unit,
    onOpenRegistration: () -> Unit,
    isBusy: Boolean,
    visibleErrorMessage: String?
) {
    var emailAddress by remember { mutableStateOf("") }
    var passwordPlaintext by remember { mutableStateOf("") }
    var isPasswordVisible by remember { mutableStateOf(false) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.secondary),
        contentAlignment = Alignment.Center
    ) {
        Column(
            verticalArrangement = Arrangement.spacedBy(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier
                .padding(horizontal = 24.dp)
                .fillMaxWidth()
        ) {
            Text("PAPERLESS", style = MaterialTheme.typography.headlineLarge, color = Color.Black)
            Text(
                "DIGITALISIEREN & VERWALTEN!",
                style = MaterialTheme.typography.labelSmall,
                color = Color.Black.copy(alpha = 0.8f)
            )
            Spacer(Modifier.height(48.dp))

            TextFieldInput(
                fieldLabel = "Benutzername",
                fieldValue = emailAddress,
                onFieldValueChange = { emailAddress = it }
            )

            SecureTextFieldInput(
                fieldLabel = "Passwort",
                fieldValue = passwordPlaintext,
                onFieldValueChange = { passwordPlaintext = it },
                isPasswordVisible = isPasswordVisible,
                onTogglePasswordVisibility = { isPasswordVisible = !isPasswordVisible },
                showEyeIcon = true
            )

            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                TextButton(
                    onClick = onOpenRegistration
                ) {
                    Text("Registrieren", color = Color.appPrimary)
                }

                Spacer(Modifier.weight(1f))

                Button(
                    onClick = { onLogin(emailAddress.trim(), passwordPlaintext) },
                    enabled = !isBusy,
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color.appPrimary,
                        contentColor = Color.secondary,
                        disabledContainerColor = Color(0xFF1E88E5).copy(alpha = 0.4f),
                        disabledContentColor = Color.White.copy(alpha = 0.6f)
                    ),
                    shape = RoundedCornerShape(8.dp)                  // „leicht abgerundet“
                ) {
                    Text(if (isBusy) "Anmelden…" else "Anmelden")
                }
            }

            if (!visibleErrorMessage.isNullOrBlank()) {
                Text(
                    text = visibleErrorMessage,
                    color = Color.error,
                    style = MaterialTheme.typography.bodySmall
                )
            }
        }
    }
}