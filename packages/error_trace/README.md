# error_trace

> **Status: draft** — plugin scaffolding exists, behavior is not yet implemented.

A mush plugin (`type = "plugin"` in `Manifest.toml`) that hooks into the
debug build pipeline to inject error tracing logic into compiled artifacts.

When complete, `error_trace` will add a `trap ERR` handler to debug builds
that prints a formatted stack trace (file, line, function call tree) whenever
a command exits with a non-zero status.

## How plugins work

Unlike regular library packages, `error_trace` is a **plugin**: it
participates in mush's build pipeline by implementing named hook functions.
The hook `__plugin_error_trace__feature_error_dumper__hook_build_debug_head_section`
is called during debug artifact generation and can inject code into the
artifact's head section.

## Installation

```toml
[dependencies]
error_trace = "mush error_trace"
```

## Status

The hook scaffold is in place. Error tracing output and the injection logic
are not yet implemented.
