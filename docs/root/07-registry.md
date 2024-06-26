---
layout: default
title: Distributed Registry
permalink: /registry/
nav_order: 7
compliance: 1
---

# Distributed Registry

Just like modern development environments, Mush is equipped with a registry where all packages are hosted. However, unlike others, this registry is distributed and not based on a proprietary CDN. Instead, it is a collection of Git nodes, each with its own maintainer. This decentralized approach ensures greater flexibility, scalability, and community involvement.

## How It Works

The `.packages` file is the cornerstone of the Mush distributed registry. It enables a decentralized system where anyone can contribute and maintain packages. Here's a breakdown of how it works and the benefits it offers.

## How It Works

The `.packages` file lists all the packages that will be installed or updated during usage. The main file is hosted at [Mush Repository](https://github.com/javanile/mush/blob/main/.packages), and everyone can request a pull to this file to add their packages or registries.

Here is an example content of the `.packages` file:

```plaintext
##
## Packages file
## 

index https://github.com/francescobianco/mush-packages

package mush https://github.com/javanile/mush.git
package console https://github.com/javanile/mush.git packages/console
package getoptions https://github.com/javanile/mush.git packages/getoptions
package code_dumper https://github.com/javanile/mush.git packages/code_dumper
package error_trace https://github.com/javanile/mush.git packages/error_trace
package build_logger https://github.com/javanile/mush.git packages/build_logger
package test_with_bashunit https://github.com/javanile/mush.git packages/test_with_bashunit
```

## Creating Your Registry

1. **Create Your Repository**: Anyone can create their repository anywhere they like.
2. **Add a `.packages` File**: In the root of your repository, create a `.packages` file that describes the packages it contains. For example:

    ```plaintext
    package foo https://github.com/user/foo.git packages/foo
    package bar https://github.com/user/bar.git packages/bar
    ```

3. **Submit a Pull Request**: To add your registry to the main index, submit a pull request to [the main Mush repository](https://github.com/javanile/mush/blob/main/.packages) adding an `index` entry with the URL to your `.packages` file.

## Handling Package Name Collisions

In a distributed registry without namespaces, package name collisions can occur. To resolve this, a CI pipeline checks for name collisions when a pull request is submitted. If a collision is detected, the pull request is flagged for review, ensuring that only unique package names are added to the main index.

## Version Constraints

The `.packages` file also supports version constraints, allowing different versions of the same package to be hosted in different repositories or directories. The version constraint syntax uses the `^` symbol.

Here are some examples:

```plaintext
## Example 1: Basic package listing
package foo https://github.com/user/foo.git
package bar https://github.com/user/bar.git

## Example 2: Version constraints
package foo^1.0.0 https://github.com/user/foo.git packages/foo_v1
package foo^2.0.0 https://github.com/another-user/foo.git packages/foo_v2

## Example 3: Multiple registries
index https://github.com/another-registry/mush-packages
index https://github.com/yet-another-registry/mush-packages

## Example 4: Mixed packages and version constraints
package toolA https://github.com/devops/toolA.git
package toolB^1.0.0 https://github.com/devops/toolB.git packages/toolB_v1
package toolB^2.0.0 https://github.com/devops/toolB.git packages/toolB_v2
```

## Benefits of a Distributed Registry

1. **Decentralization**: A distributed registry removes the need for a single point of failure. Multiple users can maintain their own package lists.
2. **Scalability**: The registry can grow organically as new users add their packages, without requiring centralized management.
3. **Redundancy**: Multiple registries ensure that even if one registry is down, others can provide the required packages.
4. **Flexibility**: Users can specify different versions of packages from different sources, accommodating a wide range of needs and use cases.
5. **Community Driven**: Contributions from various users enhance the ecosystem, making it more robust and versatile.

For more information on how to contribute and manage your packages, refer to the [Mush documentation](https://github.com/javanile/mush).
