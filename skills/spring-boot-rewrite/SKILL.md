---
name: spring-boot-rewrite
description: >
  Discover and run OpenRewrite recipes for automated code migration and refactoring
  using Arconia CLI. Use when the user wants to run a specific OpenRewrite recipe,
  discover available migration or refactoring recipes, apply automated code
  transformations, clean up code (remove unused imports, update Java version), or
  migrate between library versions beyond the built-in upgrade commands. Also use when
  the user asks about available refactoring options or wants to apply a custom rewrite
  recipe.
license: Apache-2.0
compatibility: Requires Arconia CLI installed and available on PATH.
metadata:
  author: Arconia
  source: https://github.com/arconia-io/agent-skills
---

# Discover and Run OpenRewrite Recipes

Use `arconia rewrite` to discover and run OpenRewrite recipes for automated code
migration and refactoring. This gives you full control over any recipe, unlike
the `arconia update` commands which are curated shortcuts for common upgrades.

**Always commit your project to version control before running any recipe so
you can review the changes and revert if needed.**

## Discover available recipes

List all recipes available from the bundled libraries:

```bash
arconia rewrite discover
```

This outputs all available recipes with their fully qualified names.

## Run a recipe

### Step 1: Preview with dry-run

```bash
arconia rewrite run \
    --recipe-name org.openrewrite.java.RemoveUnusedImports \
    --dry-run
```

### Step 2: Apply the recipe

```bash
arconia rewrite run \
    --recipe-name org.openrewrite.java.RemoveUnusedImports
```

### Step 3: Verify

```bash
arconia build
arconia test
```

## Run a recipe from a specific library

If the recipe is not in the bundled libraries, specify its Maven coordinates:

```bash
arconia rewrite run \
    --recipe-name io.arconia.rewrite.spring.ai.UpgradeSpringAi_1_0 \
    --recipe-library io.arconia.migrations:rewrite-spring
```

Pin a specific library version:

```bash
arconia rewrite run \
    --recipe-name io.arconia.rewrite.spring.ai.UpgradeSpringAi_1_0 \
    --recipe-library io.arconia.migrations:rewrite-spring \
    --recipe-version 1.2.0
```

## Options for `arconia rewrite run`

| Option | Required | Description |
|---|---|---|
| `--recipe-name` | Yes | Fully qualified recipe name |
| `--recipe-library` | No | Maven coordinates (`groupId:artifactId`) of the recipe library |
| `--recipe-version` | No | Specific version of the recipe library |
| `--dry-run` | No | Preview changes without applying |

## Bundled recipe libraries

These are available out of the box — no `--recipe-library` needed:

| Library | Description |
|---|---|
| `io.arconia.migrations:rewrite-arconia` | Arconia Framework version migrations |
| `io.arconia.migrations:rewrite-spring` | Spring Boot and Spring AI version migrations |
| `io.arconia.migrations:rewrite-docling` | Docling-related migrations |
| `io.arconia.migrations:rewrite-test` | Test framework migrations (JUnit, Testcontainers) |
| `org.openrewrite:rewrite-java` | Core Java recipes (unused imports, Java version updates) |
| `org.openrewrite.recipe:rewrite-java-dependencies` | Dependency management recipes |

For recipes from other libraries, consult the OpenRewrite Recipe Catalog and
use `--recipe-library` to include them.

## Workflow

1. Commit current changes to version control
2. Discover recipes: `arconia rewrite discover`
3. Pick the recipe that matches the task
4. Preview: `arconia rewrite run --recipe-name <name> --dry-run`
5. Apply: `arconia rewrite run --recipe-name <name>`
6. Verify: `arconia build && arconia test`
7. Review changes in version control

## Pass extra arguments to the build tool

```bash
arconia rewrite run --recipe-name org.openrewrite.java.RemoveUnusedImports -- --stacktrace
```

## Gotchas

- Recipe names are fully qualified Java class names (e.g.,
  `org.openrewrite.java.RemoveUnusedImports`). Use `arconia rewrite discover`
  to find the exact name.
- The `--recipe-library` flag takes Maven coordinates in `groupId:artifactId`
  format, not a file path.
- OpenRewrite recipes modify files in place. Always commit before running and
  use `--dry-run` first.
- For common framework upgrades (Spring Boot, Spring AI, Arconia Framework),
  prefer `arconia update` commands — they are simpler and use well-tested
  defaults.
- Some recipes from the OpenRewrite catalog use non-Apache licenses. Review the
  license of any recipe before running it.
