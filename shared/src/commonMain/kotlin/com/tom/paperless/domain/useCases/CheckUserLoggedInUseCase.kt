package com.tom.paperless.domain.useCases

import com.tom.paperless.auth.AuthService
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class CheckUserLoggedInUseCase : KoinComponent {
    private val authService: AuthService by inject()

    operator fun invoke(): Boolean = authService.isUserLoggedIn()
}
