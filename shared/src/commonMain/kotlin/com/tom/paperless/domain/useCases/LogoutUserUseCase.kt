package com.tom.paperless.domain.useCases

import com.tom.paperless.auth.AuthService
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class LogoutUserUseCase : KoinComponent {
    private val authService: AuthService by inject()
    suspend operator fun invoke() = authService.signOut()
}