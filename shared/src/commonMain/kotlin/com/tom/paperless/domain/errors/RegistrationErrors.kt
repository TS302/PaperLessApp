package com.tom.paperless.domain.errors

sealed interface RegistrationError {
    data object MissingFirstnameOrLastname : RegistrationError
    data object MissingEmail : RegistrationError
    data object PasswordTooShort : RegistrationError
    data object EmailAlreadyUsed : RegistrationError
    data class Unknown(val message: String?) : RegistrationError
}

/**
 * Interne Exception, die einen RegistrationError kapselt.
 * Wird nur intern im UseCase geworfen und anschließend in ein domänenspezifisches Ergebnis gemappt.
 */
class RegistrationException(
    val reason: RegistrationError
) : IllegalArgumentException(
    when (reason) {
        RegistrationError.MissingFirstnameOrLastname -> "Bitte Vor- und Nachname eingeben"
        RegistrationError.MissingEmail -> "Bitte E-Mail eingeben"
        RegistrationError.PasswordTooShort -> "Passwort zu kurz (min. 4 Zeichen)"
        RegistrationError.EmailAlreadyUsed -> "E-Mail ist bereits registriert"
        is RegistrationError.Unknown -> reason.message ?: "Unbekannter Fehler"
    }
)