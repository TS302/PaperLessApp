package com.tom.paperless.ui.views

import androidx.compose.runtime.*
import com.google.firebase.auth.FirebaseAuth
import com.tom.paperless.AndroidAuthService

@Composable
fun RootView() {
    val authService = remember { AndroidAuthService() }
    val currentUser by authService.currentUserState.collectAsState()

    var isRegistrationVisible by remember { mutableStateOf(false) }
    var isBusy by remember { mutableStateOf(false) }
    var visibleErrorMessage by remember { mutableStateOf<String?>(null) }

    if (currentUser == null) {
        LoginView(
            onLogin = { emailAddress, passwordPlaintext ->
                isBusy = true
                visibleErrorMessage = null
                authService.signInWithEmailAndPassword(
                    emailAddress = emailAddress,
                    passwordPlaintext = passwordPlaintext
                ) { errorText ->
                    visibleErrorMessage = errorText
                }
                isBusy = false
            },
            onOpenRegistration = { isRegistrationVisible = true },
            isBusy = isBusy,
            visibleErrorMessage = visibleErrorMessage
        )

        RegistrationSheet(
            isVisible = isRegistrationVisible,
            onDismissRequest = { isRegistrationVisible = false },
            onRegister = { emailAddress, passwordPlaintext ->
                isBusy = true
                visibleErrorMessage = null
                authService.registerWithEmailAndPassword(
                    emailAddress = emailAddress,
                    passwordPlaintext = passwordPlaintext
                ) { errorText ->
                    visibleErrorMessage = errorText
                }
                isBusy = false
            },
            isBusy = isBusy,
            visibleErrorMessage = visibleErrorMessage
        )
    } else {
        MainTabView(
            onLogout = { authService.signOut() }
        )
    }
    DisposableEffect(Unit) { onDispose { authService.dispose() } }
}