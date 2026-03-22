---
layout: default
title: mush legacy
permalink: /commands/mush-legacy/
parent: Manifest
nav_order: 09
---

# mush legacy

## NAME

mush legacy --- Download and register a legacy shell dependency

## SYNOPSIS

`mush legacy` [_options_] _url_...

## DESCRIPTION

Download one or more legacy shell scripts from the given URLs and register
them in the `[legacy]` section of the current package's `Manifest.toml`.

Legacy dependencies are standalone shell scripts that are not proper mush
packages. They are fetched at manifest time, cached in
`target/debug/legacy/`, and sourced at runtime via the `legacy` directive
in source files.

This command is intended as an escape hatch for integrating existing shell
utilities that predate the mush packaging system.

## OPTIONS

<dl>

<dt><code>-n</code>, <code>--name</code> <em>name</em></dt>
<dd>Override the name used to register the dependency (defaults to the
basename of the URL).</dd>

<dt><code>-h</code>, <code>--help</code></dt>
<dd>Print help information.</dd>

</dl>

## EXIT STATUS

* `0` — mush succeeded.
* `101` — mush failed to complete.

## EXAMPLES

1. Download and register a legacy utility:

       mush legacy https://example.com/utils/colors.sh

2. Register it under a custom name:

       mush legacy --name colors https://example.com/utils/colors.sh

## SEE ALSO

[mush(1)](/commands/mush/), [The Manifest File](/manifest/)
