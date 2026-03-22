---
layout: default
title: mush check
permalink: /commands/mush-check/
parent: Build
nav_order: 03
---

# mush check

## NAME

mush check --- Check the current package

## SYNOPSIS

```
mush check [OPTIONS]
```

## DESCRIPTION

Check a local package and all of its dependencies for errors. This validates
the `Manifest.toml`, resolves dependencies, and verifies sources without
producing a final compiled artifact, which is faster than a full
`mush build`.

## OPTIONS

<dl>

<dt><code>-r</code>, <code>--release</code></dt>
<dd>Check in release mode.</dd>

<dt><code>-t</code>, <code>--target</code> <em>name</em></dt>
<dd>Check for the specified target.</dd>

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

1. Check the local package for errors:

       mush check

## SEE ALSO

[mush](/commands/mush/), [mush build](/commands/mush-build/)
