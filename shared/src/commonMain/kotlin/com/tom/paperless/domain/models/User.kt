package com.tom.paperless.domain.models

data class User(
    val firstname: String,
    val lastname: String,
    val email: String,
    val password: String,
    val role: Role,
    val isLoggedIn: Boolean = false
)

enum class Role {
    USER,
    ADMIN
}