package com.tom.paperless.domain.useCases

import com.tom.paperless.data.repositories.UserRepository
import com.tom.paperless.domain.models.User
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class GetLoggedInUserUseCase() : KoinComponent {

    private val repository: UserRepository by inject()
    operator fun invoke(): User? = repository.getAll()
        .firstOrNull { it.isLoggedIn }
}