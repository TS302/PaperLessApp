package com.tom.paperless.auth

import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.tasks.await

class AndroidAuthService(
    private val firebaseAuth: FirebaseAuth
) : AuthService {

    override suspend fun signInEmailPassword(emailAddress: String, plainPassword: String) {
        firebaseAuth.signInWithEmailAndPassword(emailAddress, plainPassword).await()
    }

    override suspend fun registerEmailPassword(emailAddress: String, plainPassword: String) {
        firebaseAuth.createUserWithEmailAndPassword(emailAddress, plainPassword).await()
    }

    override suspend fun signOut() {
        firebaseAuth.signOut()
    }

    override fun isUserLoggedIn(): Boolean {
        return firebaseAuth.currentUser != null
    }
}