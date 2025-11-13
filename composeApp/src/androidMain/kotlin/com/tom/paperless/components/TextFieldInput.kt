package com.tom.paperless.components

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
fun TextFieldInput(
    fieldLabel: String,
    fieldValue: String,
    onFieldValueChange: (String) -> Unit
) {
    OutlinedTextField(
        value = fieldValue,
        onValueChange = onFieldValueChange,
        label = { Text(fieldLabel) },
        singleLine = true,
        modifier = Modifier.fillMaxWidth()
    )
}