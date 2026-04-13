---
name: spring-boot-create
description: >
  Create a new Spring Boot project from a template using Arconia CLI. Use when the user
  wants to start a new Java or Spring Boot application, scaffold a project, bootstrap
  a new service, generate a new app from a template, or initialize a new project. Also
  use when the user mentions creating a project with specific dependencies or features
  like HTTP server, AI chatbot, or similar.
license: Apache-2.0
compatibility: Requires Arconia CLI installed and available on PATH.
metadata:
  author: Arconia
  source: https://github.com/arconia-io/agent-skills
---

# Create a New Spring Boot Project

Use `arconia create` to scaffold a new Spring Boot project from a template.
Templates are pre-configured project structures distributed as OCI artifacts.

## Create a project

```bash
arconia create --name my-app --template server-http
```

Both `--name` and `--template` are required.

### Common options

| Option | Default | Description |
|---|---|---|
| `--name` | _(required)_ | Project name (used as directory name and artifact ID) |
| `--template` | _(required)_ | Template alias or full OCI reference |
| `--group` | `com.example` | Group ID (e.g., `io.arconia`) |
| `--description` | | Project description |
| `--package-name` | | Java package name (defaults from group + name) |
| `--path` | current directory | Where to create the project |

### Example with all options

```bash
arconia create \
  --name my-app \
  --template server-http \
  --group io.arconia \
  --description "My web application" \
  --package-name io.arconia.app
```

## Discover available templates

List all templates from registered catalogs:

```bash
arconia template list
```

List templates from a specific catalog:

```bash
arconia template list --name arconia-project-templates
```

## Template references

Templates can be specified as:

- **Alias** (short name): `server-http` — resolved from a registered template catalog
- **Full OCI reference**: `ghcr.io/arconia-io/arconia-templates/server-http` — fetched directly

Use aliases when available (shorter, easier to remember). Use full OCI
references when the template is not in a registered catalog.

## Workflow

1. Discover templates: `arconia template list`
2. Pick a template that matches the project requirements
3. Create the project: `arconia create --name my-app --template <template>`
4. Navigate into the project: `cd my-app`
5. Start developing: `arconia dev`

## Gotchas

- Template aliases only work if a catalog containing them is registered. If an
  alias is not found, use the full OCI reference instead.
- The `--group` defaults to `com.example`. Set it to the actual organization
  group ID (e.g., `io.arconia`) for real projects.
- The project is created in a subdirectory named after `--name` inside the
  `--path` directory (defaults to the current directory).
