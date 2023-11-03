---
layout: default
title: Packages and Modules
permalink: /packages-and-modules/
nav_order: 06
compliance: 1
---

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

## About Plugins

Mush introduces a powerful plugin system that enables users to customize and extend the behavior of the Mush compiler. 
This customization is achieved through the use of features and hooks. 
Plugins can be used to encrypt the generated script, integrate control actions, 
or even produce final programs that can be used as Git hooks.

### Features

Features represent specific customizations or extensions to the Mush compiler. 
They are defined and implemented as separate package, allowing for modularity and easy management. 
To create a feature, follow these steps:

1. Create a package with a set of function that follows the name pattern: `__plugin_{packagename}__feature_{featurename}__hook_{hookname}`.
2. In the package manifest, set the `type` to "plugin" under the `[package]` section.

### Hooks

Hooks serve as entry points where a feature can extend or modify the compiler's behavior. 
Mush provides a set of supported hooks that features can leverage for customization. 
Here are some of the supported hooks:

- `pre_compile`: Executed before compilation begins.
- `post_compile`: Executed after compilation is complete.
- `pre_link`: Executed before linking modules.
- `post_link`: Executed after linking is complete.

### Creating and using Plugins

To create a custom plugin, follow these steps:
 
1. Create a feature package as described above.
2. Define the desired hook points and implement the necessary actions within your feature package.

To use a plugin in your project, follow these steps:
 
1. Add the plugin to the `[dev-dependencies]` section of your project's Mush configuration file.
2. Enable the desired feature by setting `featurename = "true"` in the `[features]` section of your project's configuration.

### Conclusion

Mush's plugin system, features and hooks, allows users to customize the compiler's behavior and extend its capabilities. 
Whether you need to add encryption, control actions, or create unique Git hooks, 
Mush's extensibility provides the tools to tailor your development process to your specific needs.
