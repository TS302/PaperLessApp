package com.tom.paperless

import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

class AndroidAuthService {

    private val firebaseAuth: FirebaseAuth = FirebaseAuth.getInstance()

    private val _currentUserState: MutableStateFlow<FirebaseUser?> =
        MutableStateFlow(firebaseAuth.currentUser)
    val currentUserState: StateFlow<FirebaseUser?> = _currentUserState

    private val authStateListener = FirebaseAuth.AuthStateListener { authInstance ->
        _currentUserState.value = authInstance.currentUser
    }

    init {
        firebaseAuth.addAuthStateListener(authStateListener)
    }

    fun dispose() {
        firebaseAuth.removeAuthStateListener(authStateListener)
    }

    fun signInWithEmailAndPassword(
        emailAddress: String,
        passwordPlaintext: String,
        onError: (String) -> Unit
    ) {
        firebaseAuth.signInWithEmailAndPassword(emailAddress, passwordPlaintext)
            .addOnFailureListener { error ->
                onError(error.localizedMessage ?: "Anmeldung fehlgeschlagen.")
            }
    }

    fun registerWithEmailAndPassword(
        emailAddress: String,
        passwordPlaintext: String,
        onError: (String) -> Unit
    ) {
        firebaseAuth.createUserWithEmailAndPassword(emailAddress, passwordPlaintext)
            .addOnFailureListener { error ->
                onError(error.localizedMessage ?: "Registrierung fehlgeschlagen.")
            }
    }

    fun signOut() {
        firebaseAuth.signOut()
    }
}