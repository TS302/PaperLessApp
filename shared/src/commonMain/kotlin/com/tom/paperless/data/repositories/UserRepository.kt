package com.tom.paperless.data.repositories

import com.tom.paperless.domain.models.Role
import com.tom.paperless.domain.models.User

object UserRepository {

    private val users = mutableListOf(
        User(
            firstname = "Tom",
            lastname = "Salih",
            email = "tom@test.de",
            password = "1111",
            role = Role.ADMIN,
            isLoggedIn = false
        ),
        User(
            firstname = "Max",
            lastname = "Mustermann",
            email = "max@mustermann.de",
            password = "1111",
            role = Role.USER,
            isLoggedIn = false
        )
    )

    fun getAll(): List<User> = users.toList()

    fun getByEmail(email: String): User? =
        users.firstOrNull { it.email == email }

    fun add(user: User) {
        if (users.none { it.email == user.email }) {
            users += user
        }
    }

    fun update(user: User) {
        val index = users.indexOfFirst { it.email == user.email }
        if (index >= 0) {
            users[index] = user
        }
    }

    fun deleteByEmail(email: String) {
        users.removeAll { it.email == email }
    }

    fun clear() {
        users.clear()
    }
}