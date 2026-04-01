---
name: arconia-rewrite
description: >
  Run any OpenRewrite recipe to migrate or refactor a project using the Arconia
  CLI. Use this skill when the user wants to run a specific OpenRewrite recipe,
  perform automated refactoring, clean up code (e.g. remove unused imports,
  organize code), apply a custom migration, or use a third-party OpenRewrite
  recipem, even if they just say "refactor my code," "clean up imports," or
  "run a migration recipe." This is the general-purpose OpenRewrite command.
  For common upgrades (Spring Boot, Spring AI, Arconia Framework, Gradle, Maven),
  prefer arconia update instead — it provides curated shortcuts. Use arconia
  rewrite for everything else.
compatibility: Requires the Arconia CLI installed and on PATH. The project must use Maven or Gradle.
metadata:
  author: arconia-io
---

## Before you start

The project must be committed to version control. `arconia rewrite` modifies source files in place. If something goes wrong, the user needs to be able to revert.

**Always follow this sequence:**

1. Confirm the working tree is clean (`git status`).
2. Run with `--dry-run` first to preview changes.
3. Review the dry-run output with the user.
4. Run without `--dry-run` to apply.
5. Review the diff (`git diff`) and run `arconia build` or `arconia test` to verify.

## When to use this vs `arconia update`

| User intent | Command |
|---|---|
| Upgrade Spring Boot, Spring AI, Arconia Framework, Gradle, or Maven | `arconia update` (curated shortcut) |
| Run any other OpenRewrite recipe | `arconia rewrite` (this skill) |

If in doubt, check whether `arconia update` covers the task first. Use `arconia rewrite` for anything beyond those five curated upgrades.

## Usage

### Run a recipe from the OpenRewrite OSS core library

When no `--recipe-library` is specified, the recipe is looked up in the OpenRewrite OSS core library (which includes common recipes like `org.openrewrite.java.RemoveUnusedImports`).

```shell
arconia rewrite --recipe-name <fully-qualified-recipe-name> --dry-run
arconia rewrite --recipe-name <fully-qualified-recipe-name>
```

Example:

```shell
arconia rewrite --recipe-name org.openrewrite.java.RemoveUnusedImports --dry-run
arconia rewrite --recipe-name org.openrewrite.java.RemoveUnusedImports
```

### Run a recipe from a specific library

Use `--recipe-library` to specify the Maven coordinates (`groupId:artifactId`) of the library containing the recipe. The latest version is resolved automatically unless `--recipe-version` is also provided.

```shell
arconia rewrite \
    --recipe-name <fully-qualified-recipe-name> \
    --recipe-library <groupId:artifactId> \
    --dry-run
```

Example with an Arconia Migrations recipe:

```shell
arconia rewrite \
    --recipe-name io.arconia.rewrite.spring.ai.UpgradeSpringAi_1_0 \
    --recipe-library io.arconia.migrations:rewrite-spring \
    --dry-run
```

Pin to a specific library version:

```shell
arconia rewrite \
    --recipe-name io.arconia.rewrite.spring.ai.UpgradeSpringAi_1_0 \
    --recipe-library io.arconia.migrations:rewrite-spring \
    --recipe-version 1.2.0
```

## Options

| Option | Required | Description |
|---|---|---|
| `--recipe-name` | Yes | Fully-qualified name of the OpenRewrite recipe. |
| `--recipe-library` | No | Maven coordinates (`groupId:artifactId`) of the library containing the recipe. Omit to use the OpenRewrite OSS core library. |
| `--recipe-version` | No | Version of the recipe library. Omit to resolve the latest automatically. |
| `--dry-run` | No | Preview changes without modifying files. Always use this first. |
| `--verbose` or `-v` | No | Show verbose output. |
| `--` | No | Separator to pass extra parameters to the build tool. E.g. `arconia rewrite --recipe-name ... -- --stacktrace`. |

## Finding recipes

- **OpenRewrite Recipe Catalog:** https://docs.openrewrite.org/recipes, browse all available OSS and commercial recipes.
- **Arconia Migrations:** https://github.com/arconia-io/arconia-migrations, additional open-source recipes (Apache 2.0) for Spring AI, Arconia Framework, and related projects. Use `--recipe-library io.arconia.migrations:rewrite-spring`.

If the user describes what they want but doesn't know the recipe name, search the OpenRewrite Recipe Catalog for a matching recipe and suggest it.

## Gotchas

- The `--recipe-name` must be the **fully-qualified class name** of the recipe (e.g. `org.openrewrite.java.RemoveUnusedImports`), not a short name.
- When `--recipe-library` is omitted, only recipes from the **OpenRewrite OSS core library** are available. If the recipe isn't found, the user likely needs to specify the library.
- OpenRewrite recipes have **different licenses**. Recipes in the OSS core library are Apache 2.0. Others may use the Moderne Source Available License or Moderne Proprietary License. Arconia Migrations recipes are all Apache 2.0. Flag this to the user when suggesting third-party recipes.
- Build tool (Maven vs Gradle) is auto-detected. Do not try to detect it yourself or pass build-tool-specific flags.
- If `--recipe-version` is omitted, the **latest version** of the recipe library is resolved automatically. Pin the version only if the user needs reproducibility or a specific version.

## Validation

After applying a recipe:

1. Run `arconia build --skip-tests` to verify the project compiles.
2. Run `arconia build` to verify also the tests compile and pass successfully.
3. If either fails, review the errors as the migration recipe may not cover every edge case. Fix remaining issues manually and note them for the user.
