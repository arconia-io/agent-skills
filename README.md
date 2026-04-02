# Agent Skills

A collection of reusable skills that give AI agents context and knowledge about the Arconia ecosystem, enabling them to assist with tasks like development workflows, refactoring, and migrations.

## Pre-Requisites

The [Arconia CLI](https://docs.arconia.io/arconia-cli/latest/) is required to use these skills.

## Installation

The Skills included in this repository follow the [Agent Skills OCI Artifacts Specification](https://github.com/ThomasVitale/agents-skills-oci-artifacts-spec) proposed by Thomas Vitale, Arconia's founder.

Each Skill is published as an OCI artifact to GitHub Container Registry. The Skills Collection is also published as an OCI artifact that bundles all the individual Skills.

You can install Skills individually by referencing their OCI coordinates. For example, to install the `arconia-update` skill:

```shell
arconia skills add --ref ghcr.io/arconia-io/agent-skills/arconia-update
```

Notice how the Skill is now available in your project under `.agents/skills/arconia-update`. The Arconia CLI also generated two files: `skills.json` which is the manifest of all the Skills to install in the project, and `skills.lock.json` which pins the exact versions of the installed Skills and is used to reproduce the same set of Skills in another environment as well as to track new versions of the Skills.

You can always list all the Skills you have installed in your project:

```shell
arconia skills list
```

If you'd like to check for updates to your installed Skills, run:

```shell
arconia skills update
```

## Skills Collection

All the Skills in this repository are also bundled together in a Skills Collection published as an OCI artifact.

You can browse all available Skills in the Skills Collection without having to install them first. Add the Skills Collection to your project:

```shell
arconia skills collection add \
  --name arconia-skills-collection \
  --ref ghcr.io/arconia-io/agent-skills/collection
```

Then, list all the Skills in the collection:

```shell
arconia skills collection list
```

If you'd like to install a Skill from the collection, just reference it by name:

```shell
arconia skills add --name arconia-dev-services
```
