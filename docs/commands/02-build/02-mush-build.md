---
layout: default
title: mush build
permalink: /commands/mush-build/
parent: Build
nav_order: 02
---

# mush build

## NAME

mush build --- Compile the current package

## SYNOPSIS

```
mush build [OPTIONS]
```

## DESCRIPTION

Compile the local package and all of its dependencies. By default this
produces a debug build in `target/debug/`. Pass `--release` to produce an
optimized build in `target/release/`.

## OPTIONS

<dl>

<dt><code>--example</code> <em>name</em></dt>
<dd>Build only the specified example from the <code>examples/</code> directory.
The artifact is placed in <code>target/debug/examples/&lt;name&gt;</code>.</dd>

<dt><code>-r</code>, <code>--release</code></dt>
<dd>Build with optimizations. Artifacts are placed in <code>target/release/</code>
instead of <code>target/debug/</code>.</dd>

<dt><code>-t</code>, <code>--target</code> <em>name</em></dt>
<dd>Build for the specified target.</dd>

<dt><code>--no-cache</code></dt>
<dd>Disable the registry cache when building the package. Forces all
dependencies to be re-fetched.</dd>

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

1. Build the local package:

       mush build

2. Build with optimizations:

       mush build --release

3. Build a specific example:

       mush build --example hello

## SEE ALSO

[mush](/commands/mush/), [mush run](/commands/mush-run/), [mush check](/commands/mush-check/)
