package com.tom.paperless.data.models

data class User(
    val firstname: String,
    val lastname: String,
    val email: String,
    val password: String,
    val isLoggedIn: Boolean = false
)