---
layout: default
title: Installation
permalink: /installation/
nav_order: 04
parent: Miscellaneous
compliance: 1
---

# Installation

The installation of the stable version of Mush follows a standard approach, which is straightforward and ideal for most users. Installing the stable release ensures a reliable and tested version suitable for general use. Here’s the standard method:

## Installing the stable version

The easiest way to get Mush is to install the current stable release from GitHub using `curl`. This method will also create a directory at `$HOME/.mush/bin`, where you can host the scripts you’ll install subsequently.

On Linux and macOS systems, this is done as follows:

```bash
$ curl get.javanile.org/mush | sh
```

However, in some cases, alternative installation methods may be required depending on your specific needs. For example:

- Running Mush in **specialized environments**, such as servers with unique configurations.
- Using Mush in **non-Unix-based environments**, like Windows.
- Accessing **advanced or experimental features** under active development or in testing.

Below are the details for installing Mush in such scenarios.

## Installing from the development branch

To test the latest features and changes that have not yet been included in the stable release, you can install Mush from its development branch. This method is intended for advanced users or contributors who want to test new functionalities.

```bash
curl get.javanile.org/mush | bash -s -- --branch BRANCHNAME
```

Valid branch names include `develop` and `zsh`. For a complete list of available branches, visit [this page](https://github.com/javanile/mush/branches/all).

## Installing from source

If you need to build Mush from source, either to customize the tool or to integrate it into specific environments, follow these steps:

1. Clone the repository:
   ```bash
   $ git clone https://github.com/javanile/mush.git
   ```
2. Navigate to the directory:
   ```bash
   $ cd mush
   ```
3. Build and install:
   ```bash
   $ ./install.sh
   ```

Ensure you have the necessary dependencies installed beforehand.

## Installing on Windows

For Windows users, Mush can be installed using **Windows Subsystem for Linux (WSL)** or natively. Here's how:

- **Using WSL** (recommended):
    1. Enable WSL on your system and install a Linux distribution (e.g., Ubuntu).
    2. Follow the standard installation instructions for Linux.

- **Installing natively** (experimental):
    1. Download the latest release from [GitHub](https://github.com/javanile/mush/releases).
    2. Extract the files and add the executable to your PATH.

> Note: For optimal performance and compatibility, using WSL is the preferred option.

## Installing in other environments

If you’re using Mush in non-standard environments, such as embedded systems, containers, or highly restricted servers, the installation process might require customization:

1. Ensure that the environment supports a shell interpreter (e.g., bash, zsh).
2. Download the Mush script manually:
   ```bash
   $ curl -o mush.sh get.javanile.org/mush
   ```
3. Adapt the script to your environment’s requirements (e.g., custom paths, dependencies).
4. Execute the script:
   ```bash
   $ sh mush.sh
   ```

---

For further assistance or specific use cases, feel free to check the documentation or reach out to the Mush community.