---
layout: default
title: Packages and Modules
permalink: /packages-and-modules/
nav_order: 06
compliance: 1
---

# Packages and Modules

The Mush registry contains packages, many of which are also collection or modules, or contain just one module. 
Read on to understand how they differ and how they interact.

## About Packages

A **package** is a directory that is described by a `Manifest.toml` file. 
A package must contain a `Manifest.toml` file in order to be published to the Mush registry. 
For more information on creating a `Manifest.toml` file, see [Manifest reference](manifest).

Packages can be unscoped or scoped to a user or organization, and scoped packages can be private or public. 
It's worth noting that while these scenarios are envisioned, their implementation is planned for future development.

### Package formats

A package is any of the following:

* a) A folder containing a program described by a `Manifest.toml` file.
* b) A gzipped tarball containing (a).
* c) A URL that resolves to (b).
* d) A `<name>@<version>` that is published on the registry with (c).
* e) A `<name>@<tag>` that points to (d).
* f) A `<name>` that has a `latest` tag satisfying (e).
* g) A `git` url that, when cloned, results in (a).

### Mush package git URL formats

Git URLs used for npm packages can be formatted in the following ways:

- `git://github.com/user/project.git#commit-ish`
- `git+ssh://user@hostname:project.git#commit-ish`
- `git+http://user@hostname/project/blah.git#commit-ish`
- `git+https://user@hostname/project/blah.git#commit-ish`

The `commit-ish` can be any tag, sha, or branch that can be supplied as
an argument to `git checkout`. The default `commit-ish` is `main`.

## About Modules

A **module** is any file or directory in the `src/` directory that can be loaded by the `module` keyword.

To be loaded by the Mush `module` function, a module must be one of the following:

* A folder with a `module.sh` file.
* A `.sh` file.
