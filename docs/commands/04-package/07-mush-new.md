---
layout: default
title: mush new
permalink: /commands/mush-new/
parent: Package
nav_order: 07
---

# mush new(1)

## NAME

mush new --- Create a new mush package

## SYNOPSIS

`mush new` [_options_] _path_

## DESCRIPTION

Create a new mush package in the given directory. The directory must not
already exist. mush generates a `Manifest.toml`, a sample `src/main.sh`,
and initializes a git repository.

See [mush init(1)](/commands/mush-init/) for a similar command that
initializes a package in an existing directory.

## OPTIONS

<dl>

<dt><code>-n</code>, <code>--name</code> <em>name</em></dt>
<dd>Set the package name. Defaults to the directory name.</dd>

<dt><code>-t</code>, <code>--target</code> <em>name</em></dt>
<dd>Set the build target for the new package.</dd>

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

1. Create a new mush package:

       mush new mypackage

2. Create a package with a custom name:

       mush new mydir --name mypackage

## SEE ALSO

[mush(1)](/commands/mush/), [mush init(1)](/commands/mush-init/)
