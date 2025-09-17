package com.tom.paperless.ui.viewModels

import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import com.rickclephas.kmp.observableviewmodel.MutableStateFlow
import com.rickclephas.kmp.observableviewmodel.ViewModel
import com.rickclephas.kmp.observableviewmodel.stateIn
import com.tom.paperless.data.models.User
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.map

class LoginViewModel : ViewModel() {

    private val _users = MutableStateFlow(viewModelScope, value = listOf(
        User("Tom", "Salih", "tom@test.de", "1111", isLoggedIn = false)
    ))

    @NativeCoroutinesState
    val users: StateFlow<List<User>> get() = _users

    // Aktuell angemeldeter Nutzer (null = nicht eingeloggt)
    private val _currentUser = MutableStateFlow<User?>(viewModelScope, null)
    @NativeCoroutinesState
    val currentUser: StateFlow<User?> get() = _currentUser

    // Bequeme Ableitung für SwiftUI
    @NativeCoroutinesState
    val isLoggedIn: StateFlow<Boolean> =
        currentUser.map { it != null }
            .stateIn(viewModelScope, SharingStarted.Eagerly, false)

    fun login(email: String, password: String): Boolean {
        val match = _users.value.firstOrNull {
            it.email.equals(email, ignoreCase = true) && it.password == password
        }
        _currentUser.value = match
        return match != null
        print("Login successful")
    }

    fun logout() { _currentUser.value = null }
}