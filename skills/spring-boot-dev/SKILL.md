---
name: spring-boot-dev
description: >
  Build, test, and run Spring Boot applications using Arconia CLI. Use when working on
  a Java or Spring Boot project and you need to compile the application, run tests, start
  the app in development mode, build a GraalVM native executable, or run the application
  locally with dev services. Also use when the user asks to check if the project compiles,
  verify tests pass, or launch the app for local development.
license: Apache-2.0
compatibility: Requires Arconia CLI installed and available on PATH.
metadata:
  author: Arconia
  source: https://github.com/arconia-io/agent-skills
---

# Spring Boot Development

Use Arconia CLI to build, test, and run Spring Boot applications. Arconia CLI
auto-detects Maven or Gradle — you never specify the build tool.

## Run the application in development mode

```bash
arconia dev
```

This starts the app with the `dev` Spring profile active. If the project uses
Arconia Dev Services, external services (databases, message brokers, AI
inference servers, etc.) are provisioned automatically — no configuration needed.

Use `--test` (`-t`) only if the project relies on Spring Boot's native
Testcontainers approach (a `TestApplication` class in `src/test`). If the
project uses Arconia Dev Services, plain `arconia dev` is correct.

```bash
arconia dev --test
```

## Build the application

```bash
arconia build
```

Options:

| Flag | Effect |
|---|---|
| `--clean` | Remove previous build output first |
| `--skip-tests` | Skip tests during the build |
| `--native` | Produce a GraalVM native executable instead of a JAR |
| `--offline` | Build without network access |

Build a GraalVM native executable:

```bash
arconia build --native
```

### Build output locations

| Build type | Gradle | Maven |
|---|---|---|
| JVM JAR | `build/libs/` | `target/` |
| Native executable | `build/native/nativeCompile/` | `target/` |

## Run tests

```bash
arconia test
```

Options:

| Flag | Effect |
|---|---|
| `--clean` | Clean before testing |
| `--native` | Run tests in GraalVM native mode |
| `--offline` | Test without network access |

Run a specific test class:

```bash
# Gradle
arconia test -- --tests "*BookServiceTests"

# Maven
arconia test -- -Dtest=BookServiceTests
```

If the project uses Arconia Dev Services, integration tests automatically get
external services provisioned — no `@Import` annotations or configuration
classes required.

## Pass extra arguments to the build tool

Use `--` to forward arguments to the underlying Maven or Gradle command:

```bash
arconia build -- --stacktrace
arconia test -- -DmyProperty=value
arconia dev -- -Dspring.profiles.active=staging
```

## Workflow

1. Start the app: `arconia dev`
2. Make changes — the app live-reloads if Spring Boot DevTools is on the classpath
3. Run tests: `arconia test`
4. Build the final artifact: `arconia build`

## Gotchas

- `arconia build --native` requires GraalVM to be installed. Native builds are
  significantly slower than JVM builds but produce fast-startup, low-memory binaries.
- `arconia dev` without `--test` is the default and correct choice when the
  project uses Arconia Dev Services. Only add `--test` for Spring Boot's native
  Testcontainers approach.
- All commands support `--verbose` (`-v`) for detailed output when debugging
  build issues.
- The `--` separator is required to distinguish Arconia CLI flags from build
  tool arguments. Everything after `--` is passed directly to Maven or Gradle.
