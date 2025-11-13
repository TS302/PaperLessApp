package com.tom.paperless.theme

import androidx.compose.ui.graphics.Color


// Grundfarben (deine bisherigen Werte)
val Color.Companion.appPrimary: Color get() = Color(0xFF51688C)   // kräftiges Blau-Grau
val Color.Companion.appSecondary: Color get() = Color(0xFFF5FAFF) // sehr hell (für OnPrimary, Hintergründe)
val Color.Companion.error: Color get()       = Color(0xFFAE5360)

// Sekundärer, heller App-Hintergrund (wie iOS Secondary)
val Color.Companion.secondary: Color get()   = Color(0xFFF5FAFF)

// Helle Container-Variante der Primärfarbe (für Tabbar-Hintergrund, Chips etc.)
val Color.Companion.appPrimaryContainerLight: Color get() = Color(0xFFDCE6F3)
// Text/Icon-Farbe auf dem hellen Primär-Container
val Color.Companion.onAppPrimaryContainerLight: Color get() = Color(0xFF263245)

// Dunkle Container-Variante (für Dark Mode)
val Color.Companion.appPrimaryContainerDark: Color get() = Color(0xFF2C3D55)
// Text/Icon-Farbe auf dem dunklen Primär-Container
val Color.Companion.onAppPrimaryContainerDark: Color get() = Color(0xFFE6EEF7)

//val Color.Companion.appPrimary: Color get() = Color(0xFF51688C)
//val Color.Companion.appSecondary: Color get() = Color(0xFFF5FAFF)
//val Color.Companion.error: Color get() = Color(0xFFAE5360)
//val Color.Companion.secondary: Color get() = Color(0xFFF5FAFF)