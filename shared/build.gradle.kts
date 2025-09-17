import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.plugin.mpp.apple.XCFramework

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    id("com.google.devtools.ksp") version "2.2.10-2.0.2"
    id("com.rickclephas.kmp.nativecoroutines") version "1.0.0-ALPHA-47"
    id("org.jetbrains.kotlin.plugin.serialization") version libs.versions.kotlin.get()
}


kotlin {
    androidTarget {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }
    val xcf = XCFramework()
    listOf(
        iosArm64(),
        iosSimulatorArm64()
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "Shared"
            isStatic = true
            xcf.add(this)
        }
    }
    
    sourceSets {
        all {
            languageSettings.optIn("kotlinx.cinterop.ExperimentalForeignApi")
            languageSettings.optIn("kotlin.experimental.ExperimentalObjCName")
        }
        commonMain.dependencies {

            // KMP OVM & NativeCoroutines
            api(libs.kmp.observableviewmodel.core)
            implementation(libs.kmp.nativecoroutines.core)

        }
        commonTest.dependencies {
            implementation(libs.kotlin.test)
        }
    }
}

android {
    namespace = "com.tom.paperless.shared"
    compileSdk = libs.versions.android.compileSdk.get().toInt()
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    defaultConfig {
        minSdk = libs.versions.android.minSdk.get().toInt()
    }
}