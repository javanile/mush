---
layout: default
title: Plugins
permalink: /plugins/
nav_order: 07
compliance: 1
---

# Plugins

Mush introduces a powerful plugin system that enables users to customize and extend the behavior of the Mush compiler.
This customization is achieved through the use of features and hooks.
Plugins can be used to encrypt the generated script, integrate control actions,
or even produce final programs that can be used as Git hooks.

## Features

Features represent specific customizations or extensions to the Mush compiler.
They are defined and implemented as separate package, allowing for modularity and easy management.
To create a feature, follow these steps:

1. Create a package with a set of function that follows the name pattern: `__plugin_{packagename}__feature_{featurename}__hook_{hookname}`.
2. In the package manifest, set the `type` to "plugin" under the `[package]` section.

## Hooks

Hooks serve as entry points where a feature can extend or modify the compiler's behavior.
Mush provides a set of supported hooks that features can leverage for customization.
Here are some of the supported hooks:

- `pre_compile`: Executed before compilation begins.
- `post_compile`: Executed after compilation is complete.
- `pre_link`: Executed before linking modules.
- `post_link`: Executed after linking is complete.

## Creating and using Plugins

To create a custom plugin, follow these steps:

1. Create a feature package as described above.
2. Define the desired hook points and implement the necessary actions within your feature package.

To use a plugin in your project, follow these steps:

1. Add the plugin to the `[dev-dependencies]` section of your project's Mush configuration file.
2. Enable the desired feature by setting `featurename = "true"` in the `[features]` section of your project's configuration.

## Conclusion

Mush's plugin system, features and hooks, allows users to customize the compiler's behavior and extend its capabilities.
Whether you need to add encryption, control actions, or create unique Git hooks,
Mush's extensibility provides the tools to tailor your development process to your specific needs.
