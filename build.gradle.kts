plugins {
    java
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

val osName = System.getProperty("os.name").lowercase()
val osArch  = System.getProperty("os.arch").lowercase()

repositories {
    mavenCentral()
    // JOGL 2.5.0 is not on Maven Central (gap between 2.3.2 and 2.6.0); use JOGAMP mirror
    maven { url = uri("https://jogamp.org/deployment/maven") }
}

dependencies {
    // Processing 4 core
    implementation(group = "org.processing", name = "core", version = "4.4.7")

    // JOGL (main JARs, no natives)
    implementation(group = "org.jogamp.jogl",    name = "jogl-all",   version = "2.5.0")
    implementation(group = "org.jogamp.gluegen", name = "gluegen-rt", version = "2.5.0")

    // JOGL natives (platform-specific, via Maven classifier)
    when {
        osName.contains("mac") -> {
            runtimeOnly(group = "org.jogamp.jogl",    name = "jogl-all",   version = "2.5.0", classifier = "natives-macosx-universal")
            runtimeOnly(group = "org.jogamp.gluegen", name = "gluegen-rt", version = "2.5.0", classifier = "natives-macosx-universal")
        }
        osName.contains("windows") -> {
            runtimeOnly(group = "org.jogamp.jogl",    name = "jogl-all",   version = "2.5.0", classifier = "natives-windows-amd64")
            runtimeOnly(group = "org.jogamp.gluegen", name = "gluegen-rt", version = "2.5.0", classifier = "natives-windows-amd64")
        }
        else -> {
            // Linux
            val arch = when {
                osArch.contains("aarch64") || osArch.contains("arm64") -> "aarch64"
                else -> "amd64"
            }
            runtimeOnly(group = "org.jogamp.jogl",    name = "jogl-all",   version = "2.5.0", classifier = "natives-linux-$arch")
            runtimeOnly(group = "org.jogamp.gluegen", name = "gluegen-rt", version = "2.5.0", classifier = "natives-linux-$arch")
        }
    }
}

sourceSets {
    main {
        java { setSrcDirs(listOf("src/java")) }
        resources {
            setSrcDirs(listOf("src/java"))
            exclude("**/*.java")
        }
    }
}

// Extract native libraries from JOGL native JARs into build/natives/
// JOGL needs the .dylib/.so/.dll files accessible via java.library.path
val nativesDir = layout.buildDirectory.dir("natives")

val extractNatives by tasks.registering {
    group = "build"
    description = "Extract JOGL native libraries from JARs"
    outputs.dir(nativesDir)

    doLast {
        val outDir = nativesDir.get().asFile
        outDir.mkdirs()
        configurations.runtimeClasspath.get()
            .resolvedConfiguration.resolvedArtifacts
            .filter { it.classifier?.contains("natives") == true }
            .forEach { artifact ->
                zipTree(artifact.file).visit {
                    if (!isDirectory && (name.endsWith(".dylib") || name.endsWith(".so") || name.endsWith(".dll"))) {
                        file.copyTo(File(outDir, name), overwrite = true)
                    }
                }
            }
    }
}

// JVM args for Processing 4 on Java 17
val processingJvmArgs = listOf(
    "--add-opens", "java.desktop/sun.awt=ALL-UNNAMED",
    "--add-opens", "java.desktop/java.awt=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "-Djava.library.path=${nativesDir.get().asFile.absolutePath}",
)

// Dynamically register a run task for each sketch directory
// Usage: ./gradlew Sketch20230824a  or  ./gradlew sketch20230824a
file("src/java/sketches").listFiles { f -> f.isDirectory }
    ?.sortedBy { it.name }
    ?.forEach { dir ->
        val dirName = dir.name
        val className = dirName.replaceFirstChar { it.uppercase() }
        val fullClassName = "sketches.$dirName.$className"

        tasks.register<JavaExec>(className) {
            group = "sketches"
            description = "Run $className"
            classpath = sourceSets.main.get().runtimeClasspath
            mainClass.set(fullClassName)
            workingDir = projectDir
            jvmArgs = processingJvmArgs
            dependsOn(extractNatives)
        }

        if (dirName != className) {
            tasks.register(dirName) {
                group = "sketches"
                description = "Alias for $className"
                dependsOn(className)
            }
        }
    }
