// android/build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ─── PRODUCTION ALIGNMENT FIX: REMOVED RELATIVE OUT-OF-PROPS REDIRECTIONS ───
// This keeps compile artifacts locked safely inside your active local directory layout,
// preventing Gradle from dropping metadata definitions across drive slices.

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
