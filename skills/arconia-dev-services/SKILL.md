---
name: arconia-dev-services
description: >
  Add and configure Arconia Dev Services in a Spring Boot project. Use this
  skill when the user wants to set up local infrastructure for development or
  testing — databases (PostgreSQL, MySQL, MariaDB, MongoDB, Oracle, Redis,
  Valkey), message brokers (Kafka, RabbitMQ, Pulsar, Artemis), observability
  tools (Grafana LGTM, OpenTelemetry Collector, Phoenix), AI services (Ollama),
  document processing (Docling), or LDAP (LLDAP). Also use it when the user
  mentions Testcontainers setup, Docker Compose alternatives, dev services,
  "I need a local database," or asks how to run their app with external
  services without manual configuration. Arconia Dev Services are a
  zero-configuration, single-dependency solution that automatically provisions
  containerized services — no boilerplate code, no test configuration classes,
  and no workflow changes required.
compatibility: >
  Requires Docker or Podman running. The project must use Spring Boot with
  Maven or Gradle.
metadata:
  author: Arconia
---

## What are Arconia Dev Services?

Arconia Dev Services automatically provision containerized external services (databases, brokers, etc.) for Spring Boot applications during **development and testing**. Add a single dependency, and the service starts as an OCI container, wires itself into the application context, and shuts down when the application stops. No code, no configuration, no workflow changes.

They are built on top of Testcontainers and Spring Boot's Service Connection mechanism, but eliminate all the boilerplate that Spring Boot's native Testcontainers support requires (no `@TestConfiguration` classes, no `TestApplication` main class, no `@ServiceConnection` annotations, no `@Import` on test classes).

Dev Services are **excluded from production builds** — they only run in development and test modes.

## Adding a Dev Service

### 1. Add the dependency

Each service has its own module: `io.arconia:arconia-dev-services-<service-name>`.

**Gradle:**

```groovy
dependencies {
  testAndDevelopmentOnly 'io.arconia:arconia-dev-services-<service-name>'
}

dependencyManagement {
  imports {
    mavenBom "io.arconia:arconia-bom:<arconia-version>"
  }
}
```

**Maven:**

```xml
<dependency>
    <groupId>io.arconia</groupId>
    <artifactId>arconia-dev-services-<service-name></artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
```

With a BOM in `<dependencyManagement>`:

```xml
<dependency>
    <groupId>io.arconia</groupId>
    <artifactId>arconia-bom</artifactId>
    <version>${arconia.version}</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```

### 2. Run the application

No special commands needed. Use the standard workflow:

```shell
./gradlew bootRun        # Gradle
./mvnw spring-boot:run   # Maven
arconia dev              # Arconia CLI
```

The container starts automatically and the application connects to it. For example, a PostgreSQL Dev Service overrides `spring.datasource.url`, `spring.datasource.username`, and `spring.datasource.password` transparently.

### 3. Run tests

No extra annotations or imports required. Just write standard `@SpringBootTest` tests — the Dev Service is provisioned automatically for the test context.

```shell
./gradlew test    # Gradle
./mvnw test       # Maven
arconia test      # Arconia CLI
```

## Supported services

| Category | Service | Artifact ID |
|---|---|---|
| Data Stores | MariaDB | `arconia-dev-services-mariadb` |
| Data Stores | MongoDB | `arconia-dev-services-mongodb` |
| Data Stores | MongoDB Atlas | `arconia-dev-services-mongodb-atlas` |
| Data Stores | MySQL | `arconia-dev-services-mysql` |
| Data Stores | Oracle | `arconia-dev-services-oracle` |
| Data Stores | Oracle XE | `arconia-dev-services-oracle-xe` |
| Data Stores | PostgreSQL | `arconia-dev-services-postgresql` |
| Data Stores | Redis | `arconia-dev-services-redis` |
| Data Stores | Valkey | `arconia-dev-services-valkey` |
| Event Brokers | Artemis | `arconia-dev-services-artemis` |
| Event Brokers | Kafka | `arconia-dev-services-kafka` |
| Event Brokers | Pulsar | `arconia-dev-services-pulsar` |
| Event Brokers | RabbitMQ | `arconia-dev-services-rabbitmq` |
| Observability | Grafana LGTM | `arconia-dev-services-lgtm` |
| Observability | OpenTelemetry Collector | `arconia-dev-services-otel-collector` |
| Observability | Phoenix | `arconia-dev-services-phoenix` |
| AI / Document Processing | Docling | `arconia-dev-services-docling` |
| AI / Inference | Ollama | `arconia-dev-services-ollama` |
| Identity | LLDAP | `arconia-dev-services-lldap` |

## Configuration

All Dev Services are configured via `application.yml` (or `application.properties`) under the `arconia.dev.services.<service-name>` prefix. All are **enabled by default** with sensible defaults.

### Common properties (all services)

| Property | Description |
|---|---|
| `arconia.dev.services.<name>.enabled` | Enable/disable the Dev Service. |
| `arconia.dev.services.<name>.image-name` | Container image to use. |
| `arconia.dev.services.<name>.environment` | Environment variables for the container. |
| `arconia.dev.services.<name>.port` | Fixed host port (0 = random, the default). |
| `arconia.dev.services.<name>.shared` | Share the container across applications (dev mode only). |
| `arconia.dev.services.<name>.startup-timeout` | Max wait time for the service to start. |
| `arconia.dev.services.<name>.resources` | Classpath/filesystem files to copy into the container (read-only). |
| `arconia.dev.services.<name>.volumes` | Host directories to mount into the container (read-write). |
| `arconia.dev.services.<name>.network-aliases` | Network aliases for the container. |

Individual services may have additional properties. Refer to the Arconia docs for service-specific options: `https://docs.arconia.io/arconia/latest/dev-services/<service-name>/`.

### Global disable

Set `arconia.dev.services.enabled=false` to disable **all** Dev Services at once. This overrides individual service settings.

## Resource mappings

Copy files from the classpath or host filesystem into the container at startup (read-only). Source paths are resolved automatically (classpath first, then filesystem), or use explicit prefixes: `classpath:` or `file:`.

```yaml
arconia:
  dev:
    services:
      otel-collector:
        resources:
          - source-path: otel-collector-config.yml
            container-path: /etc/otelcol-contrib/config.yaml
```

## Volume mappings

Mount host directories into the container (read-write, bidirectional). Use only when mutability is needed; prefer resource mappings otherwise.

```yaml
arconia:
  dev:
    services:
      postgresql:
        volumes:
          - host-path: ./postgresql/data
            container-path: /var/lib/postgresql/data/pgdata
```

## Sharing Dev Services across applications

Shared Dev Services let multiple applications reuse the same container (e.g., a shared Kafka broker or Grafana LGTM stack). Sharing is only supported in **dev mode**, never in tests.

**Pre-requisite:** enable Testcontainers reusable containers by adding this to `~/.testcontainers.properties`:

```properties
testcontainers.reuse.enable=true
```

Then set `arconia.dev.services.<name>.shared=true`. Some services (brokers, observability) have sharing enabled by default.

Reusable containers are **not automatically removed**. They must be stopped manually via Docker/Podman.

## Spring Boot DevTools integration

When Spring Boot DevTools is present, Dev Service containers **survive live restarts**. The container keeps running across code changes so there is no wait time or state loss. Add DevTools with:

**Gradle:** `developmentOnly 'org.springframework.boot:spring-boot-devtools'`
**Maven:** `<scope>runtime</scope> <optional>true</optional>` for `spring-boot-devtools`.

## Actuator endpoint

If Spring Boot Actuator is on the classpath, a `/actuator/devservices` endpoint is available in dev mode. It shows container IDs, image names, port mappings, and status for all running Dev Services.

```shell
http :8080/actuator/devservices
http :8080/actuator/devservices/postgresql
```

## Gotchas

- The dependency scope matters. Use `testAndDevelopmentOnly` in Gradle or `<scope>runtime</scope> <optional>true</optional>` in Maven to ensure Dev Services are **excluded from production**.
- Dev Services **take precedence** over manually configured connection properties (`spring.datasource.url`, etc.). If the user has explicit properties and a Dev Service for the same technology, the Dev Service wins.
- A **container runtime** (Docker or Podman) must be installed and running. If it's not, the application will fail to start with a Testcontainers error.
- The PostgreSQL Dev Service automatically switches to the `pgvector/pgvector` image when Spring AI PGVector is on the classpath.
- Do **not** create `TestApplication` classes, `@TestConfiguration` container beans, or use `bootTestRun`/`spring-boot:test-run`. That is the manual Spring Boot approach that Arconia Dev Services replace entirely.
- Dev Services can **co-exist** with existing Spring Boot Testcontainers or Docker Compose setups. Adopt incrementally: add Arconia Dev Services for some technologies while keeping existing setups for others.
- Container startup order is sequential by default. Set `spring.testcontainers.beans.startup=parallel` for parallel startup.
- Fixed ports (`arconia.dev.services.<name>.port`) can cause conflicts. Use them only when other tools need a known port.
