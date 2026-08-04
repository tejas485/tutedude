// android/settings.gradle.kts

pluginManagement {
    val localProperties = java.util.Properties()
    val localPropertiesFile = file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { localProperties.load(it) }
    }

    val flutterSdkPath = localProperties.getProperty("flutter.sdk")
        ?: throw GradleException("Flutter SDK path not found in local.properties. Ensure you have run 'flutter pub get'.")

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"

    // ─── STABLE AND FLUTTER COMPLIANT AGP BUILD ROUTE (KOTLIN DSL MATRIX) ───
    id("com.android.application") version "8.9.1" apply false

    // Aligns with your modern Kotlin 2.2.20 ecosystem profile
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
