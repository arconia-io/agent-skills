---
name: spring-boot-image-build
description: >
  Build container images for Spring Boot applications using Arconia CLI. Use when
  the user wants to containerize their application, build a Docker/OCI image, create
  a container image using Cloud Native Buildpacks or a Dockerfile/Containerfile,
  push an image to a registry, or build multi-architecture container images. Also
  use when the user mentions packaging for Kubernetes, deploying to a container
  platform, or creating production images.
license: Apache-2.0
compatibility: Requires Arconia CLI installed and available on PATH.
metadata:
  author: Arconia
  source: https://github.com/arconia-io/agent-skills
---

# Build Container Images for Spring Boot

Use `arconia image build` to package a Spring Boot application as a container
image. Two strategies are available:

| Strategy | Command | Dockerfile needed? |
|---|---|---|
| **Buildpacks** | `arconia image build buildpacks` | No |
| **Dockerfile** | `arconia image build dockerfile` | Yes |

Both require an OCI container runtime (Podman or Docker) installed and running.

## Buildpacks (recommended for most projects)

Cloud Native Buildpacks auto-detect the application type and produce an
optimised image without a Dockerfile.

```bash
arconia image build buildpacks
```

With a custom image name:

```bash
arconia image build buildpacks --image-name ghcr.io/arconia-io/my-app:1.0.0
```

### Buildpacks options

| Option | Default | Description |
|---|---|---|
| `--image-name` | | Image name and optional tag |
| `--builder-image` | _(from Spring Boot plugin)_ | Buildpacks Builder image |
| `--run-image` | _(from Builder)_ | Buildpacks Run image (base image of the produced container) |
| `--clean-cache` | `false` | Clean the Buildpacks local cache before building |
| `--publish-image` | `false` | Publish the image to an OCI registry after building |
| `--image-platform` | | Target platform(s) (e.g., `linux/amd64`, `linux/arm64`) |
| `--clean` | `false` | Clean build the application before building the image |
| `--skip-tests` | `false` | Skip tests during the application build |

### Multi-architecture images

Specify multiple platforms to build a multi-arch OCI image index:

```bash
arconia image build buildpacks \
  --image-name ghcr.io/arconia-io/my-app:1.0.0 \
  --image-platform linux/amd64 \
  --image-platform linux/arm64 \
  --publish-image
```

Multi-arch builds require `--publish-image` because the OCI image index must be
assembled from manifests already present in a registry.

### Publish to a registry

Authenticate with the registry first, then use `--publish-image`:

```bash
podman login ghcr.io
arconia image build buildpacks \
  --image-name ghcr.io/arconia-io/my-app:1.0.0 \
  --publish-image
```

## Dockerfile / Containerfile

Use this strategy when you need full control over the image build.

```bash
arconia image build dockerfile --image-name ghcr.io/arconia-io/my-app:1.0.0
```

The command looks for a Dockerfile/Containerfile in these locations (in order):

1. `Containerfile` (project root)
2. `Dockerfile` (project root)
3. `src/main/podman/Containerfile`
4. `src/main/podman/Dockerfile`
5. `src/main/docker/Containerfile`
6. `src/main/docker/Dockerfile`

### Dockerfile options

| Option | Default | Description |
|---|---|---|
| `--image-name` or `-t` | _(required)_ | Image name and optional tag |
| `--dockerfile`, `--containerfile`, or `-f` | _(auto-detected)_ | Path to the Dockerfile/Containerfile |
| `--oci-runtime` | _(auto-detected: Podman then Docker)_ | OCI runtime to use (`docker` or `podman`) |

### Example multi-stage Dockerfile

```dockerfile
FROM docker.io/library/eclipse-temurin:25-noble AS builder
WORKDIR /builder
# Adjust to 'target/*.jar' for Maven
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=tools -jar application.jar extract --layers --destination extracted

FROM docker.io/library/eclipse-temurin:25-jre-noble
RUN useradd spring
USER spring
WORKDIR /application
COPY --from=builder /builder/extracted/dependencies/ ./
COPY --from=builder /builder/extracted/spring-boot-loader/ ./
COPY --from=builder /builder/extracted/snapshot-dependencies/ ./
COPY --from=builder /builder/extracted/application/ ./
ENTRYPOINT ["java", "-jar", "application.jar"]
```

## Pass extra arguments to the build tool

Use `--` to forward arguments to the underlying Maven or Gradle command:

```bash
arconia image build buildpacks -- --stacktrace
arconia image build buildpacks -- -DmyProperty=value
```

## Workflow

1. Build and test the application: `arconia build && arconia test`
2. Build the image: `arconia image build buildpacks` (or `dockerfile`)
3. Verify locally: `podman run --rm -p 8080:8080 <image-name>`
4. Publish: add `--publish-image` (buildpacks) or push manually (dockerfile)

## Gotchas

- An OCI container runtime (Podman or Docker) must be installed and running.
  The CLI prefers Podman and falls back to Docker.
- `arconia image build buildpacks` does **not** require `--image-name` — it
  defaults to the Spring Boot plugin configuration. `arconia image build
  dockerfile` **requires** `--image-name`.
- Multi-arch builds with multiple `--image-platform` values require
  `--publish-image` because the manifest list must be assembled in a registry.
- To push images, authenticate with the registry first (e.g., `podman login
  ghcr.io`).
- All commands support `--verbose` (`-v`) for detailed output when debugging
  build issues.
- The `--` separator is required to distinguish Arconia CLI flags from build
  tool arguments. Everything after `--` is passed directly to Maven or Gradle.
