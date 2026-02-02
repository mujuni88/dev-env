---
name: java-context
description: |
  Activate this skill whenever working with a Java or Kotlin Netflix project.
  Keywords:
  - Java, JDK
  - Gradle, gradlew, build.gradle, build.gradle.kts
  - Nebula, dependencies.lock, gradle.lockfile
  - SBN, Spring Boot Netflix, spring-boot-netflix-bom
  - DGS, GraphQL, gRPC, WebClient
  - JUnit, Mockito, AssertJ, JaCoCo
  - @SpringBootTest, test slices
  - Newt app-type: java-project or jvm-library
user-invocable: false
allowed_tools: mcp__NECP
---

# Java Development

## Project Information

### Java Language Version

Find the Java version in the `build.gradle` file. Look for the `toolchain` block in the `java` configuration:

```groovy
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}
```

Different modules within a project can use different Java versions. Check each module's build file.

### SBN Version Detection

**SBN 3 projects** have this block in `build.gradle`:

```groovy
dependencyRecommendations {
    mavenBom module: 'com.netflix.spring:spring-boot-netflix-bom:latest.release'
}
```

**SBN 2 projects** use:

```groovy
dependencyRecommendations {
    mavenBom module: 'com.netflix.spring.bom:spring-boot-netflix-internalplatform-recommendations:latest.release'
}
```

To find the actual locked version, check `dependencies.lock` for the `com.netflix.spring:spring-boot-netflix` entry:

```json
"com.netflix.spring:spring-boot-netflix": {
    "locked": "3.5.24",
    "transitive": []
}
```

## Build Commands

All Java projects use Gradle. Run `./gradlew` from the repo root only—never from subdirectories.

| Command | Purpose |
|---------|---------|
| `./gradlew build` | Full build |
| `./gradlew test` | Run all tests |
| `./gradlew test --tests <name>` | Run specific test |
| `./gradlew test -Pcom.netflix.gradle-predictive-test-selection.enabled=false` | Run tests without predictive selection |

## Netflix Engineering Context

Use the `get-netflix-engineering-context` tool to get Netflix-specific information about:
- Spring Boot Netflix (SBN) configuration and best practices
- DGS (Domain Graph Service) and GraphQL
- gRPC setup and usage
- WebClient configuration
- Nebula and Gradle build patterns
- JDK and testing best practices

## Code Generation Rules

- Use the latest language features for the project's Java version (var keyword, multiline strings, `List.of()`)
- Prefer the `var` keyword for local variables

## Testing

Use Mockito for mocking with static imports:

```java
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
```

**Guidelines:**
- Use `Mockito.RETURNS_DEEP_STUBS` when mocking builder-style APIs
- Set up nested mocks properly so one mock returns another
- Never adjust `verify()` invocation counts to compensate for mock setup—this indicates incorrect setup
- Extract shared mock setup to `@BeforeEach` methods
- Use AssertJ assertions: `import static org.assertj.core.api.Assertions.assertThat`
- In SBN applications, prefer `@SpringBootTest` with test slices over pure unit tests with mocks

## Nebula (Netflix Build System)

Nebula is the Netflix Build Language plugin for Gradle that provides specific functionality for the Netflix environment. When the Nebula plugin is used, we call our Gradle system "Nebula." It enables building, packaging, and publishing artifacts for JVM builds through Gradle.

### Dependency Locking

Dependency locking saves resolved dependency versions to a lock file, ensuring subsequent builds use the same versions. This prevents unexpected changes in the dependency graph.

**Two locking mechanisms exist at Netflix:**

#### 1. Nebula Dependency Locking (Default)

Uses the `gradle-dependency-lock-plugin` with `dependencies.lock` files located next to each `build.gradle` file.

| Task | Purpose |
|------|---------|
| `generateLock` + `saveLock` | Regenerate locks based on build.gradle and latest library versions |
| `updateLock` | Update a single dependency and its transitive dependencies |
| `deleteLock` | Delete lock files in project and subprojects |

**Global locking** uses a single lockfile shared across all subprojects:
- `generateGlobalLock`, `saveGlobalLock`, `updateGlobalLock`, `deleteGlobalLock`

#### 2. Core Gradle Locking

Enabled by adding to `gradle.properties`:
```properties
systemProp.nebula.features.coreLockingSupport=true
```

Uses `gradle.lockfile` format matching the OSS Gradle locking mechanism.

To generate or update locks:
```bash
./gradlew resolve --write-locks
```

This creates or overwrites the lock state for each resolved configuration.

**Core Gradle Locking advantages:**
- More OSS-like behavior
- Fewer merge conflicts (JSON lockfiles are hard to read and merge)
- Supports buildscript dependency locking (plugin versions)

Core Gradle Locking will become the default in upcoming Nebula versions.

### Predictive Test Selection

Gradle Enterprise Predictive Test Selection automatically selects and executes tests most relevant to a code change, providing faster feedback.

To disable and run all tests:
```bash
./gradlew test -Pcom.netflix.gradle-predictive-test-selection.enabled=false
```

### Code Coverage

Nebula applies the `netflix.test-coverage` plugin which bundles JaCoCo.

The `netflixTestCoverageReport` task:
- Runs after all test tasks
- Aggregates coverage from all modules
- Generates XML and HTML reports

Report location: `$PROJECT_ROOT/build/reports/jacoco/netflixTestCoverageReport/netflixTestCoverageReport.xml`
