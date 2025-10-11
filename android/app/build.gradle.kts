plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream
import java.io.File

// Load keystore properties
val keystorePropertiesFile = file("key.properties") // file should be in android/app/
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
} else {
    throw GradleException("Missing key.properties file at ${keystorePropertiesFile.absolutePath}")
}

android {
    namespace = "com.nlehn.riddles"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.nlehn.riddles"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
                ?: throw GradleException("Missing keyAlias in key.properties")
            keyPassword = keystoreProperties.getProperty("keyPassword")
                ?: throw GradleException("Missing keyPassword in key.properties")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
                ?: throw GradleException("Missing storeFile in key.properties")
            storePassword = keystoreProperties.getProperty("storePassword")
                ?: throw GradleException("Missing storePassword in key.properties")
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
