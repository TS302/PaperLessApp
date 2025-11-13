package com.tom.paperless.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.selection.LocalTextSelectionColors
import androidx.compose.foundation.text.selection.TextSelectionColors
import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Shapes
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp


private fun lightScheme(): ColorScheme = lightColorScheme(
    primary            = Color.appPrimary,
    onPrimary          = Color.appSecondary,

    primaryContainer   = Color.appPrimaryContainerLight,
    onPrimaryContainer = Color.onAppPrimaryContainerLight,

    surface            = Color.appPrimaryContainerLight,
    onSurface          = Color.onAppPrimaryContainerLight,

    surfaceVariant     = Color(0xFFC5D2EA),
    onSurfaceVariant   = Color(0xFF4A5568),

    error              = Color.error,
    onError            = Color.White,

    background         = Color.White,
    onBackground       = Color(0xFF121212),
    outline            = Color(0xFFB0B0B0),
)

private fun darkScheme(): ColorScheme = darkColorScheme(
    primary            = Color.appPrimary,
    onPrimary          = Color.appSecondary,

    primaryContainer   = Color.appPrimaryContainerDark,
    onPrimaryContainer = Color.onAppPrimaryContainerDark,

    surface            = Color.appPrimaryContainerDark,
    onSurface          = Color.onAppPrimaryContainerDark,

    surfaceVariant     = Color(0xFF2A2F36),
    onSurfaceVariant   = Color(0xFFB9C2CC),

    error              = Color.error,
    onError            = Color.Black,

    background         = Color(0xFF121212),
    onBackground       = Color(0xFFECECEC),
    outline            = Color(0xFF4C4C4C),
)

val RoundedShapes = Shapes(
    small  = RoundedCornerShape(6.dp),
    medium = RoundedCornerShape(8.dp),
    large  = RoundedCornerShape(10.dp)
)

@Composable
fun PaperLessTheme(
    useDarkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val selectionColors = TextSelectionColors(
        handleColor = Color.appPrimary,
        backgroundColor = Color.appPrimary.copy(alpha = 0.25f)
    )

    val baseScheme = if (useDarkTheme) darkScheme() else lightScheme()

    val colorSchemeNoTint = baseScheme.copy(
        surfaceTint = Color.Unspecified
    )

    CompositionLocalProvider(LocalTextSelectionColors provides selectionColors) {
        MaterialTheme(
            colorScheme = colorSchemeNoTint,
            shapes = RoundedShapes,
            typography = MaterialTheme.typography,
            content = content
        )
    }
}