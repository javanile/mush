---
layout: default
title: mush init
permalink: /commands/mush-init/
parent: Package
nav_order: 05
---

# mush init(1)

## NAME

mush init --- Create a new mush package in an existing directory

## SYNOPSIS

`mush init` [_options_] [_path_]

## DESCRIPTION

Create a new mush package in the current directory (or in _path_ if given).
This generates a `Manifest.toml` and a sample `src/main.sh` if no source
files are present. If the directory is not already inside a VCS repository,
a new git repository is created.

If a `Manifest.toml` already exists in the target directory, the command
exits with an error.

See [mush new(1)](/commands/mush-new/) for a similar command that creates the
package in a brand-new directory.

## OPTIONS

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

1. Create a mush package in the current directory:

```shell
mush init
```

2. Create a mush package in a specific directory:

```shell
mush init path/to/mypackage
```

## SEE ALSO

[mush(1)](/commands/mush/), [mush new(1)](/commands/mush-new/)
