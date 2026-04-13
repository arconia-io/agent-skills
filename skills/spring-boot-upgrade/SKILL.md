---
name: spring-boot-upgrade
description: >
  Upgrade Spring Boot, Spring AI, Arconia Framework, Gradle, or Maven versions using
  Arconia CLI. Use when the user wants to upgrade or update their project's framework
  version, migrate to a newer Spring Boot or Spring AI release, update the Gradle or
  Maven wrapper, or bring dependencies to their latest versions. Also use when the user
  mentions version migration, dependency upgrades, or keeping the project up to date.
license: Apache-2.0
compatibility: Requires Arconia CLI installed and available on PATH.
metadata:
  author: Arconia
  source: https://github.com/arconia-io/agent-skills
---

# Upgrade Frameworks and Build Tools

Use `arconia update` to upgrade frameworks and build tool wrappers. Each command
runs a tested OpenRewrite migration recipe that handles dependency bumps,
deprecated API replacements, configuration renames, and more.

**Always commit your project to version control before running any upgrade so
you can review the changes and revert if needed.**

## Available upgrade commands

| Command | What it upgrades | `--to-version` default |
|---|---|---|
| `arconia update spring-boot` | Spring Boot | `4.0` |
| `arconia update spring-ai` | Spring AI | `2.0` |
| `arconia update framework` | Arconia Framework | `0.25` |
| `arconia update gradle` | Gradle wrapper | _(latest)_ |
| `arconia update maven` | Maven wrapper | _(latest)_ |

## Recommended workflow

### Step 1: Preview changes with dry-run

Always preview before applying:

```bash
arconia update spring-boot --to-version=4.0 --dry-run
```

Review the output to understand what files will be modified.

### Step 2: Apply the upgrade

```bash
arconia update spring-boot --to-version=4.0
```

### Step 3: Verify the upgrade

```bash
arconia build
arconia test
```

If tests fail, review the changes in version control and fix any issues the
automated migration could not handle.

## Upgrade to a specific version

Use `--to-version` to target a specific release:

```bash
arconia update spring-boot --to-version=3.4
arconia update spring-ai --to-version=1.1
arconia update framework --to-version=0.24
```

## Update build tool wrappers

Gradle and Maven wrapper updates do not take a `--to-version` flag — they
update to the latest version automatically:

```bash
arconia update gradle
arconia update maven
```

These update `gradle/wrapper/gradle-wrapper.properties` or
`.mvn/wrapper/maven-wrapper.properties` respectively.

## Pass extra arguments to the build tool

```bash
arconia update spring-boot --to-version=4.0 -- --stacktrace
```

## Gotchas

- OpenRewrite modifies files in place. Always commit before upgrading so you can
  `git diff` the changes and revert with `git checkout .` if needed.
- The `--dry-run` flag previews changes without modifying files. Always use it
  first, especially for major version upgrades.
- Migration recipes handle most changes automatically (dependency versions,
  renamed APIs, configuration properties) but some manual adjustments may be
  needed after major upgrades. Always run tests after applying.
- The `--to-version` flag is not available for `arconia update gradle` and
  `arconia update maven` — they always update to the latest version.
- All upgrade commands use recipes from the Arconia Migrations project. For
  custom or additional recipes, use `arconia rewrite run` instead.
