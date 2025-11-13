package com.tom.paperless

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import com.tom.paperless.theme.PaperLessTheme
import com.tom.paperless.ui.views.RootView

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)

        setContent {
            PaperLessTheme {
                RootView()
            }
        }
    }
}

@Preview
@Composable
fun AppAndroidPreview() {
    App()
}