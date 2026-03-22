---
layout: default
title: mush install
permalink: /commands/mush-install/
parent: Package
nav_order: 06
---

# mush install

## NAME

mush install --- Build and install a mush package

## SYNOPSIS

`mush install` [_options_] [_package_]...\
`mush install` [_options_] `--path` _path_\
`mush install` [_options_] `--list`

## DESCRIPTION

Build and install a mush package. The default installation root is
`$MUSH_HOME/bin` (typically `~/.mush/bin`).

Packages can be installed by name (resolved from the mush registry), or
directly from a local path with `--path`.

When installing by name, mush clones the package source into
`$MUSH_HOME/registry/src/<package>/<version>/` and builds it in release
mode. The resulting binary is linked into `$MUSH_HOME/bin/`.

For packages with `type = "meta"` in their `Manifest.toml`, no binary is
produced — only the declared dependencies are resolved and installed.

## OPTIONS

### Install Options

<dl>

<dt><code>--path</code> <em>path</em></dt>
<dd>Install from a local filesystem path instead of the registry.</dd>

<dt><code>--version</code> <em>version</em></dt>
<dd>Specify the version to install. Accepts a branch name, tag, or exact
version string.</dd>

<dt><code>-f</code>, <code>--force</code></dt>
<dd>Force overwriting an existing installation of the same package.</dd>

<dt><code>-l</code>, <code>--list</code></dt>
<dd>List all installed packages and their versions.</dd>

<dt><code>--show-plugins</code></dt>
<dd>List all installed mush plugins.</dd>

<dt><code>-t</code>, <code>--target</code> <em>name</em></dt>
<dd>Build for the specified target.</dd>

</dl>

### Display Options

<dl>

<dt><code>-v</code>, <code>--verbose</code></dt>
<dd>Use verbose output. Repeat to increase level (<code>-vv</code>, <code>-vvv</code>, etc.).</dd>

<dt><code>-q</code>, <code>--quiet</code></dt>
<dd>Suppress mush log messages.</dd>

<dt><code>-h</code>, <code>--help</code></dt>
<dd>Print help information.</dd>

</dl>

## ENVIRONMENT

See [the reference](/environment-variables/) for details on environment
variables that mush reads.

## EXIT STATUS

* `0` — mush succeeded.
* `101` — mush failed to complete.

## EXAMPLES

1. Install a package by name:

       mush install ripgrep

2. Install the package in the current directory:

       mush install --path .

3. Install a specific version:

       mush install mypackage --version 1.2.0

4. List installed packages:

       mush install --list

## SEE ALSO

[mush(1)](/commands/mush/), [mush new(1)](/commands/mush-new/), [mush publish(1)](/commands/mush-publish/)
