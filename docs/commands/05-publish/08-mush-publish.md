---
layout: default
title: mush publish
permalink: /commands/mush-publish/
parent: Publish
nav_order: 08
---

# mush publish

## NAME

mush publish --- Upload a package to the registry

## SYNOPSIS

`mush publish` [_options_]

## DESCRIPTION

Build the current package in release mode and upload it to the mush registry.
This performs the following steps:

1. Validates the `Manifest.toml`.
2. Builds the package with `mush build --release`.
3. Uploads the package to the registry.

## OPTIONS

<dl>

<dt><code>--allow-dirty</code></dt>
<dd>Allow publishing from a working directory with uncommitted VCS changes.</dd>

<dt><code>-n</code>, <code>--name</code> <em>name</em></dt>
<dd>Override the package name used for publishing.</dd>

<dt><code>-t</code>, <code>--target</code> <em>name</em></dt>
<dd>Publish for the specified target.</dd>

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

1. Publish the current package:

       mush publish

2. Publish even with uncommitted changes:

       mush publish --allow-dirty

## SEE ALSO

[mush(1)](/commands/mush/), [mush build(1)](/commands/mush-build/), [mush install(1)](/commands/mush-install/)
