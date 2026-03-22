---
layout: default
title: mush run
permalink: /commands/mush-run/
parent: Build
nav_order: 04
---

# mush run(1)

## NAME

mush run --- Run a binary or example of the local package

## SYNOPSIS

`mush run` [_options_] [`--` _args_]

`mush run --example` _name_ [`--` _args_]

`mush run --bin` _name_ [`--` _args_]

## DESCRIPTION

Compiles and immediately runs a target from the local package. By default, `mush
run` builds and executes the main binary (`src/main.sh`). Use `--example` to
compile and run one of the example scripts from the `examples/` directory.

Arguments following `--` are forwarded verbatim to the script's `main()`
function.

## OPTIONS

### Target Selection

<dl>

<dt><code>--example</code> <em>name</em></dt>
<dd>Compile and run the example at <code>examples/&lt;name&gt;.sh</code>.
The compiled artifact is placed in <code>target/debug/examples/&lt;name&gt;</code>
and executed immediately. See <a href="#the-example-system">The Example System</a>
for more details.</dd>

<dt><code>--bin</code> <em>name</em></dt>
<dd>Run the specified binary target from <code>src/</code>.</dd>

</dl>

### Display Options

<dl>

<dt><code>-v</code>, <code>--verbose</code></dt>
<dd>Use verbose output. Repeat the flag to increase verbosity level
(<code>-vv</code>, <code>-vvv</code>, etc.).</dd>

<dt><code>-q</code>, <code>--quiet</code></dt>
<dd>Suppress mush log messages.</dd>

<dt><code>-h</code>, <code>--help</code></dt>
<dd>Print help information.</dd>

</dl>

## THE EXAMPLE SYSTEM

Examples are standalone scripts placed in the `examples/` directory at the root
of the package. Each file is an independent runnable script that demonstrates
how to use the package.

### Directory layout

```
my-package/
├── Manifest.toml
├── src/
│   ├── main.sh        # main binary
│   └── lib.sh         # library (optional)
└── examples/
    ├── hello.sh       # mush run --example hello
    ├── greet.sh       # mush run --example greet
    └── args.sh        # mush run --example args
```

### Writing an example

Every example must define a `main()` function. Arguments passed after `--` on
the command line are forwarded to it:

```bash
# examples/greet.sh
main() {
  local name="${1:-World}"
  echo "Hello, ${name}!"
}
```

```bash
# examples/args.sh
main() {
  echo "Received ${#} argument(s):"
  local i=1
  for arg in "$@"; do
    echo "  [${i}] ${arg}"
    i=$((i + 1))
  done
}
```

### How compilation works

When you run `mush run --example <name>`, mush:

1. Resolves the source file at `examples/<name>.sh`.
2. Compiles a debug entrypoint at `target/debug/examples/<name>`.
3. Executes the artifact, forwarding any extra arguments to `main()`.

The debug entrypoint uses the mush debug API to source files live from the
project directory at runtime instead of embedding them. This means edits to
your source files take effect on the next `mush run` without a separate build
step.

### Compiled artifact structure

A compiled debug example follows the [Blueprint](../../miscellaneous/07-blueprint.md)
spec. The relevant sections are:

| Section | Name | Content |
|---------|------|---------|
| SC000 | blueprint | Blueprint metadata |
| SC001 | file-meta | Path and type of this artifact (`build-entrypoint`) |
| SC002 | debug-entrypoint-init | Debug bootstrap marker |
| SC003 | config | Package name, target paths, project root |
| SC004 | debug-api | `debug()` function and runtime module loader |
| SC005 | execution | `debug init` + source of the example + `main "$@"` |

The execution section (SC005) for an example named `hello` looks like:

```bash
# @section_code: SC005
# @section_name: execution
debug init
debug file "${MUSH_DEBUG_PATH}/examples/hello.sh"
main "$@"
```

## EXAMPLES

Run the main binary:

```
mush run
```

Run an example:

```
mush run --example hello
```

Run an example and pass arguments to it:

```
mush run --example greet -- Alice
mush run --example args -- foo bar baz
```

List available examples when the requested one is not found:

```
$ mush run --example unknown
error: no example target named 'unknown'.

Available example targets:
    hello
    greet
    args
```

## EXIT STATUS

* `0`: The script ran successfully.
* `101`: mush failed to compile or the script exited with an error.

## SEE ALSO

[mush(1)](mush.md), [mush build(1)](mush-build.md)
