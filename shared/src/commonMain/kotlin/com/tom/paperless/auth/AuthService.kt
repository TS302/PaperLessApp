package com.tom.paperless.auth

interface AuthService {
    suspend fun signInEmailPassword(emailAddress: String, plainPassword: String)
    suspend fun registerEmailPassword(emailAddress: String, plainPassword: String)
    suspend fun signOut()
    fun isUserLoggedIn(): Boolean
}