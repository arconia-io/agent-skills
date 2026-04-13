<p align="center">
  <img src="arconia-logo.png" alt="Arconia" width="200" />
</p>

<h1 align="center">Agent Skills</h1>

<p align="center">
  A collection of reusable <a href="https://agentskills.io/">Agent Skills</a> for the Java, Spring Boot, and <a href="https://arconia.io/">Arconia</a> ecosystem, published as OCI artifacts and consumable through the <a href="https://docs.arconia.io/arconia-cli/latest/">Arconia CLI</a> or any other tool implementing the <a href="https://github.com/ThomasVitale/agents-skills-oci-artifacts-spec">Agent Skills OCI Artifacts Specification</a>.
</p>

<p align="center">
  <a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="Apache 2.0 License" /></a>
</p>

---

## 📦&nbsp; Skills

Each skill in this repository is packaged and published as an OCI artifact. The full set is also published as a Skills Collection, which lets you browse and install skills by name instead of using full OCI references.

These artifacts follow the [Agent Skills OCI Artifacts Specification](https://github.com/ThomasVitale/agents-skills-oci-artifacts-spec), which enables standard OCI-based distribution, versioning, discovery, and reproducible installation.

| Name | Description |
|------|-------------|
| `spring-boot-create` | Create a new Spring Boot project from OCI-backed templates using `arconia create`. |
| `spring-boot-dev` | Build, test, and run Spring Boot applications with `arconia dev`, `arconia build`, and `arconia test`. |
| `spring-boot-image-build` | Build container images for Spring Boot applications with `arconia image build` using Buildpacks or Dockerfile strategies. |
| `spring-boot-rewrite` | Discover and run OpenRewrite recipes with `arconia rewrite` for automated refactoring and custom migrations. |
| `spring-boot-upgrade` | Upgrade Spring Boot, Spring AI, Arconia Framework, Gradle, and Maven with `arconia update`. |

## ⚡&nbsp; Quick Start

The [Arconia CLI](https://docs.arconia.io/arconia-cli/latest/) is required to use these skills.

The `arconia skills` and `arconia skills collection` commands are currently experimental and may evolve in future Arconia CLI releases.

**1. Add the Skills Collection**

Register the collection with the Arconia CLI so the skills are discoverable locally:

```shell
arconia skills collection add \
  --name arconia-skills \
  --ref ghcr.io/arconia-io/agent-skills/collection
```

**2. Browse available skills**

List skills from your registered collections:

```shell
arconia skills collection list
```

Or inspect just this collection:

```shell
arconia skills collection list --name arconia-skills
```

**3. Install a skill by name**

Once the collection is registered, you can install a skill without knowing its full OCI reference:

```shell
arconia skills add --name spring-boot-dev
```

**4. Or install a skill directly from its OCI reference**

Direct installation also works when you already know the artifact coordinates:

```shell
arconia skills add --ref ghcr.io/arconia-io/agent-skills/spring-boot-upgrade
```

After installation, the skill is extracted under `.agents/skills/<skill-name>`. The Arconia CLI also maintains:

- `skills.json`, the declarative manifest of the skills required by your project.
- `skills.lock.json`, the lock file that records the resolved artifact digests for reproducible installs and updates.

**5. Reinstall and update skills**

Install all skills declared in `skills.json`:

```shell
arconia skills install
```

List installed skills:

```shell
arconia skills list
```

Update installed skills:

```shell
arconia skills update
```

## 🔗&nbsp; Multi-Agent Support

Arconia installs skills into `.agents/skills` by default. You can also expose the same skill set to supported agent vendors with the `--agent` option. Arconia keeps `.agents/skills` as the primary location and creates vendor-specific symlinks so multiple agents can share the same installed skills without duplicating content.

For example:

```shell
arconia skills add \
  --name spring-boot-dev \
  --agent claude \
  --agent vibe
```

The agent layout is persisted in `skills.json`, so `arconia skills install`, `arconia skills update`, and `arconia skills remove` can reproduce and manage the same setup consistently.

## 📙&nbsp; Documentation

The Arconia CLI documentation covers the full skills workflow in detail:

- [Skills commands](https://docs.arconia.io/arconia-cli/latest/skills/skills/)
- [Skills Collection commands](https://docs.arconia.io/arconia-cli/latest/skills/collection/)
- [Agent Skills as OCI Artifacts](https://www.thomasvitale.com/agent-skills-as-oci-artifacts/)

## 🛡️&nbsp; Security

The security process for reporting vulnerabilities is described in [SECURITY.md](SECURITY.md).

## 🖊️&nbsp; License

This project is licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for more information.
