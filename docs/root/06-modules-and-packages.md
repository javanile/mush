---
layout: default
title: Modules and Packages  
permalink: /modules-and-packages/
nav_order: 6
compliance: 1
---

# Modules and Packages 

## About Modules

A **module** is any file or directory in the `src/` directory that can be loaded by the `module` keyword.

To be loaded by the Mush `module` function, a module must be one of the following:

* A folder with a `module.sh` file.
* A `.sh` file.

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

## Package Versions

Mush packages fully support the Semantic Versioning (SemVer) system, ensuring clear and predictable version management. This allows developers to specify version constraints and dependencies with precision, avoiding compatibility issues across different package releases. More details on how version constraints are handled within Mush can be found here.

### Basic Comparisons

There are two elements to the comparisons. First, a comparison string is a list of space or comma separated AND comparisons. These are then separated by || (OR) comparisons. For example, ">= 1.2 < 3.0.0 || >= 4.2.3" is looking for a comparison that's greater than or equal to 1.2 and less than 3.0.0 or is greater than or equal to 4.2.3.

The basic comparisons are:

- =: equal (aliased to no operator)
- !=: not equal
- \>: greater than
- <: less than
- \>=: greater than or equal to
- <=: less than or equal to

### Working With Prerelease Versions

Pre-releases, for those not familiar with them, are used for software releases prior to stable or generally available releases. Examples of pre-releases include development, alpha, beta, and release candidate releases. A pre-release may be a version such as 1.2.3-beta.1 while the stable release would be 1.2.3. In the order of precedence, pre-releases come before their associated releases. In this example 1.2.3-beta.1 < 1.2.3.

According to the Semantic Version specification, pre-releases may not be API compliant with their release counterpart. It says,

A pre-release version indicates that the version is unstable and might not satisfy the intended compatibility requirements as denoted by its associated normal version.

SemVer's comparisons using constraints without a pre-release comparator will skip pre-release versions. For example, >=1.2.3 will skip pre-releases when looking at a list of releases while >=1.2.3-0 will evaluate and find pre-releases.

The reason for the 0 as a pre-release version in the example comparison is because pre-releases can only contain ASCII alphanumerics and hyphens (along with . separators), per the spec. Sorting happens in ASCII sort order, again per the spec. The lowest character is a 0 in ASCII sort order (see an ASCII Table)

Understanding ASCII sort ordering is important because A-Z comes before a-z. That means >=1.2.3-BETA will return 1.2.3-alpha. What you might expect from case sensitivity doesn't apply here. This is due to ASCII sort ordering which is what the spec specifies.

### Hyphen Range Comparisons

There are multiple methods to handle ranges and the first is hyphens ranges. These look like:

- 1.2 - 1.4.5 which is equivalent to >= 1.2 <= 1.4.5
- 2.3.4 - 4.5 which is equivalent to >= 2.3.4 <= 4.5

Note that 1.2-1.4.5 without whitespace is parsed completely differently; it's parsed as a single constraint 1.2.0 with prerelease 1.4.5.

### Wildcards In Comparisons

The x, X, and * characters can be used as a wildcard character. This works for all comparison operators. When used on the = operator it falls back to the patch level comparison (see tilde below). For example,

- 1.2.x is equivalent to >= 1.2.0, < 1.3.0
- \>= 1.2.x is equivalent to >= 1.2.0
- <= 2.x is equivalent to < 3
- \* is equivalent to >= 0.0.0

### Tilde Range Comparisons (Patch)

The tilde (~) comparison operator is for patch level ranges when a minor version is specified and major level changes when the minor number is missing. For example,

- ~1.2.3 is equivalent to >= 1.2.3, < 1.3.0
- ~1 is equivalent to >= 1, < 2
- ~2.3 is equivalent to >= 2.3, < 2.4
- ~1.2.x is equivalent to >= 1.2.0, < 1.3.0
- ~1.x is equivalent to >= 1, < 2

### Caret Range Comparisons (Major)

The caret (^) comparison operator is for major level changes once a stable (1.0.0) release has occurred. Prior to a 1.0.0 release the minor versions acts as the API stability level. This is useful when comparisons of API versions as a major change is API breaking. For example,

- ^1.2.3 is equivalent to >= 1.2.3, < 2.0.0
- ^1.2.x is equivalent to >= 1.2.0, < 2.0.0
- ^2.3 is equivalent to >= 2.3, < 3
- ^2.x is equivalent to >= 2.0.0, < 3
- ^0.2.3 is equivalent to >=0.2.3 <0.3.0
- ^0.2 is equivalent to >=0.2.0 <0.3.0
- ^0.0.3 is equivalent to >=0.0.3 <0.0.4
- ^0.0 is equivalent to >=0.0.0 <0.1.0
- ^0 is equivalent to >=0.0.0 <1.0.0

