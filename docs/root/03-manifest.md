---
layout: default
title: Manifest File
permalink: /manifest/
nav_order: 3
compliance: 1
---

# The Manifest Format

Every mush package has a `Manifest.toml` file at its root. It is written in
[TOML] format and contains the metadata needed to build, install, and publish
the package.

[TOML]: https://toml.io

Every manifest file consists of the following sections:

* [`[package]`](#the-package-section) — Defines the package identity.
    * [`name`](#the-name-field) — The name of the package.
    * [`version`](#the-version-field) — The current version (semver).
    * [`authors`](#the-authors-field) — The authors of the package.
    * [`description`](#the-description-field) — A short description of the package.
    * [`license`](#the-license-field) — The package license identifier.
    * [`edition`](#the-edition-field) — The Mush edition.
    * [`type`](#the-type-field) — The package type (`bin`, `plugin`, `meta`).

* Dependency tables:
    * [`[dependencies]`](#the-dependencies-section) — Runtime dependencies.
    * [`[dev-dependencies]`](#the-dev-dependencies-section) — Dependencies for tests and examples only.

---

## The `[package]` section

The first section in every `Manifest.toml` is `[package]`.

```toml
[package]
name = "my-tool"
version = "0.1.0"
authors = ["Alice <alice@example.com>"]
description = "A short description of my tool."
license = "MIT"
edition = "2022"
```

The required fields are [`name`](#the-name-field) and [`version`](#the-version-field).
All other fields are optional but recommended.

### The `name` field

The package name is the identifier used to refer to the package when listed as
a dependency by another package, and is used as the default name of the
compiled binary.

Rules:
* Only alphanumeric characters, `-`, and `_` are allowed.
* Cannot be empty.
* Must be unique within the registry it is published to.

### The `version` field

Mush uses [Semantic Versioning](https://semver.org/). The version is a string
with three numeric components: `MAJOR.MINOR.PATCH`.

```toml
[package]
version = "1.2.0"
```

Guidelines:
* Before `1.0.0`, anything goes; increment the minor version for breaking changes.
* After `1.0.0`, increment the major version for breaking changes.
* Use three components: `1.0.0` rather than `1.0`.

### The `authors` field

An optional array listing the people or organizations considered authors of the
package. An email address may be included in angle brackets.

```toml
[package]
authors = ["Sam Sunset", "Mr. Bianco <bianco@javanile.org>"]
```

### The `description` field

A short plain-text description of what the package does. Displayed by registries
when listing or searching packages.

```toml
[package]
description = "A build system for shell scripts."
```

### The `license` field

The [SPDX] license identifier for the package.

[SPDX]: https://spdx.org/licenses/

```toml
[package]
license = "MIT"
```

### The `edition` field

The mush edition the package targets. The edition determines which language
features and standard library behaviours are available.

```toml
[package]
edition = "2022"
```

If omitted, the oldest supported edition is assumed for backwards compatibility.
[`mush new`] always sets `edition` explicitly to the latest stable value.

### The `type` field

The `type` field declares the nature of the package. It controls what mush
expects to find in the package directory and what it will do with it.

| Value | Description |
| ----- | ----------- |
| `"bin"` | A runnable binary package (default). Must contain source files. |
| `"plugin"` | A mush plugin that extends the mush CLI itself. |
| `"meta"` | A dependency-only package with no source code (see below). |

If `type` is omitted, `"bin"` is assumed.

```toml
[package]
type = "meta"
```

#### The `meta` type

A **meta package** carries no source code of its own. Its sole purpose is to
act as a named shortcut for a curated set of dependencies — think of it as a
reusable dependency list with a version and a name.

```toml
[package]
name = "web-stack"
version = "1.0.0"
type = "meta"
description = "Full web stack: nginx + php + mysql."

[dependencies]
nginx = "apt nginx | yum nginx"
php   = "apt php8.2 | yum php"
mysql = "apt mysql-server | yum mysql-server"
```

Installing `web-stack` installs the entire stack in one command:

```sh
mush install web-stack
```

**Rules enforced for `type = "meta"`:**

* A `src/` directory MUST NOT be present — mush will error if sources are found.
* Only `[dependencies]` and `[dev-dependencies]` are meaningful; all other
  sections (`[run]`, `[bin]`, `[lib]`, etc.) are ignored with a warning.
* The package produces no compiled artifact and cannot be executed directly.

**Typical use cases:**

* Environment presets (`ci-tools`, `dev-environment`, `production-stack`)
* System dependency bundles (`build-essentials`, `monitoring-stack`)
* Opinionated collections that a team wants to version and share

---

## The `[dependencies]` section

The `[dependencies]` table declares the packages required at runtime. Mush
resolves and installs them automatically when running `mush install`.

### Mush package dependencies

A mush package dependency is declared with its name as the key and a version
constraint as the value:

```toml
[dependencies]
console = "1.0.0"
getoptions = "*"
code_dumper = ">=0.3.0"
```

Version constraint syntax:

| Constraint | Meaning |
| ---------- | ------- |
| `"*"` | Any version |
| `"1.2.0"` | Exact version |
| `">=1.2.0"` | At least this version |
| `"^1.2.0"` | Compatible with `1.2.x` (semver caret) |

### System dependencies — multi-registry support

Mush scripts sometimes need external system binaries to be present (e.g. `jq`,
`curl`, `git`). You can declare these in `[dependencies]` using the
**multi-registry syntax**:

```toml
[dependencies]
jq = "apt jq | yum jq"
```

The value is a `|`-separated list of **registry expressions**. Each expression
has the form `<registry> <package>`. Mush evaluates the list left-to-right and
uses the first registry that is available on the host system.

#### Install behaviour

When `mush install` encounters a system dependency:

1. **Already installed** — the binary is detected on `$PATH`; the dependency is
   skipped silently.
2. **Missing, running as root** — Mush selects the appropriate registry,
   installs the package automatically, and continues.
3. **Missing, not running as root** — Mush halts and prints a clear suggestion
   with the exact command the user should run to install the missing dependency:

```
[mush] Dependency 'jq' is not installed.
[mush] Run the following command to install it:

    sudo apt install jq

[mush] Then re-run: mush install
```

#### Multiple registries example

The same package may have different names across package managers. List all
known variants separated by `|`:

```toml
[dependencies]
jq      = "apt jq | yum jq | brew jq | pacman jq"
ripgrep = "apt ripgrep | brew ripgrep | pacman ripgrep"
```

Mush picks the first registry whose binary (`apt`, `yum`, `brew`, `pacman`, …)
is found on the system.

#### Mixed mush and system dependencies

Mush and system dependencies can coexist freely in the same `[dependencies]`
table:

```toml
[dependencies]
# mush package
console = "*"

# system binary
jq = "apt jq | yum jq"
```

Mush distinguishes them automatically: a value that starts with a registry name
followed by a package name is treated as a system dependency; everything else
is treated as a mush package version constraint.

---

## The `[dev-dependencies]` section

The `[dev-dependencies]` table follows exactly the same syntax as
`[dependencies]`, but the packages declared here are installed **only** for
development workflows (tests, examples, benchmarks). They are never included
when the package is installed as a dependency by another project.

```toml
[dev-dependencies]
shellcheck = "apt shellcheck | brew shellcheck"
bats       = "apt bats | brew bats"
```

System dev-dependencies follow the same multi-registry and privilege rules
described above.

**Typical use cases for `[dev-dependencies]`:**
* Linters and static analysis tools (e.g. `shellcheck`)
* Test runners (e.g. `bats`)
* Development utilities that are not needed at runtime
