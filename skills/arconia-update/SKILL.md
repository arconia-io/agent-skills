---
name: arconia-update
description: >
  Upgrade Spring Boot, Spring AI, Arconia Framework, Gradle, or Maven versions
  in a project using the Arconia CLI. Use this skill when the user wants to
  update, upgrade, or migrate their project to a newer version of any of these
  frameworks or build tools, even if they just say "update my dependencies,"
  "migrate to Spring Boot 4," or "upgrade my project." These commands run
  automated OpenRewrite migration recipes that go far beyond version bumps:
  they replace deprecated APIs, rename configuration properties, and update
  imports. Do not attempt manual version edits in pom.xml or build.gradle,
  always use arconia update.
compatibility: Requires the Arconia CLI installed and on PATH. The project must use Maven or Gradle.
metadata:
  author: Arconia
---

## Before you start

The project must be committed to version control. All `arconia update` commands modify source files in place. If something goes wrong, the user needs to be able to revert.

**Always follow this sequence:**

1. Confirm the working tree is clean (`git status`).
2. Run with `--dry-run` first to preview changes.
3. Review the dry-run output with the user.
4. Run without `--dry-run` to apply.
5. Review the diff (`git diff`) and run `arconia build` or `arconia test` to verify.

## Commands

### Update Spring Boot

```shell
arconia update spring-boot --to-version=<version> --dry-run
arconia update spring-boot --to-version=<version>
```

`--to-version` accepts a minor version (e.g. `4.0`, `3.5`). Default: `4.0`.

### Update Spring AI

```shell
arconia update spring-ai --to-version=<version> --dry-run
arconia update spring-ai --to-version=<version>
```

`--to-version` accepts a minor version (e.g. `2.0`). Default: `1.1`.

### Update Arconia Framework

```shell
arconia update framework --to-version=<version> --dry-run
arconia update framework --to-version=<version>
```

`--to-version` accepts a minor version (e.g. `0.24`). Default: `0.20`.

### Update Gradle wrapper

```shell
arconia update gradle --dry-run
arconia update gradle
```

No `--to-version` option — always updates to the latest Gradle release.

### Update Maven wrapper

```shell
arconia update maven --dry-run
arconia update maven
```

No `--to-version` option — always updates to the latest Maven release.

## Common options

All update commands support:

| Option | Description |
|---|---|
| `--dry-run` | Preview changes without modifying files. Always use this first. |
| `--verbose` or `-v` | Show verbose output from the underlying build tool. |
| `--` | Separator to pass extra parameters to the underlying build tool. E.g. `arconia update spring-boot --to-version=4.0 -- --stacktrace`. |

The alias `arconia upgrade` works the same as `arconia update`.

## Gotchas

- These commands do **much more than bump a version number**. They run full OpenRewrite migration recipes that replace deprecated APIs, rename configuration properties, update imports, and restructure code. Never attempt to replicate this manually by editing `pom.xml` or `build.gradle`.
- The `--to-version` value is a **minor version** (e.g. `4.0`), not a full patch version (e.g. `4.0.3`). The recipe handles selecting the correct patch.
- The `--to-version` defaults vary per command and may be outdated. Ask the user what version they want to target. If they say "latest" and you don't know the latest, use the default and mention it.
- `arconia update gradle` and `arconia update maven` have **no `--to-version` option** — they always update to the latest.
- These are **curated shortcuts**. If the user needs to run a recipe not covered by these commands (e.g. a custom migration, removing unused imports, or a third-party recipe), use `arconia rewrite` instead.
- Build tool (Maven vs Gradle) is auto-detected. Do not try to detect it yourself or pass build-tool-specific flags.

## Validation

After applying an update:

1. Run `arconia build --skip-tests` to verify the project compiles.
2. Run `arconia build` to verify also the tests compile and pass successfully.
3. If either fails, review the errors as the migration recipe may not cover every edge case. Fix remaining issues manually and note them for the user.
