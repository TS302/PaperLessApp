import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.plugin.mpp.apple.XCFramework

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    alias(libs.plugins.kotlinSerialization)
    id("com.rickclephas.kmp.nativecoroutines") version libs.versions.kmp.nativecoroutines.get()
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
            languageSettings.optIn("kotlin.uuid.ExperimentalUuidApi")
            languageSettings.optIn("kotlin.experimental.ExperimentalObjCRefinement")
        }
        commonMain.dependencies {

            implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.6.0")

            // KMP OVM & NativeCoroutines
            implementation(libs.kmp.observableviewmodel.core)
            implementation(libs.kmp.nativecoroutines.core)
//            api(libs.kmp.observableviewmodel.core)
//            implementation(libs.kmp.nativecoroutines.core)
            implementation(libs.koin.core)

            implementation(libs.kotlinx.serialization.json)
            implementation(libs.kotlinx.coroutines.core)


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