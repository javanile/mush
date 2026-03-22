# console

Colored terminal output for mush packages. Provides a set of functions that
print styled messages to stderr, consistent with the cargo/rust output
convention: right-aligned bold labels followed by a description.

Output is automatically suppressed when the `QUIET` flag is set, and some
functions are gated behind the `VERBOSE` level.

## Installation

Add `console` as a dependency in your `Manifest.toml`:

```toml
[dependencies]
console = "mush console"
```

Then import it in your source file:

```bash
extern package console
```

## Functions

### `console_status label message`

Print a **green** label and a message. Use for strong positive events that
mark a real state change: package compiled, installed, etc.

```bash
console_status "Compiling" "mypackage v1.0.0"
console_status "Installed" "mypackage v1.0.0"
```

Output:
```
   Compiling mypackage v1.0.0
   Installed mypackage v1.0.0
```

### `console_info label message`

Print a **cyan** label and a message. Only shown when `VERBOSE > 0`. Use for
soft log messages: checking state, satisfying a condition, skipping a step.

```bash
console_info "Checking" "dependency 'jq'"
console_info "Satisfied" "system dependency 'jq' already installed"
```

### `console_warning label message`

Print a **yellow** label and a message. Use for non-fatal warnings.

```bash
console_warning "Warning" "installed branch 'main' but manifest declares '1.0.0'"
```

### `console_log label message`

Print a **white/bold** label and a message. General purpose logging, always
visible (unless `QUIET` is set).

```bash
console_log "Note" "something worth mentioning"
```

### `console_hint message`

Print a plain bold hint line to stderr. Used to suggest a follow-up action
after an error.

```bash
console_hint "run the following command to install it:"
printf "\n    sudo apt install jq\n\n" >&2
console_hint "then re-run: mush install"
```

### `console_error message`

Print a **red** `error:` prefix followed by the message to stderr.

```bash
console_error "no example target named 'unknown'."
```

Output:
```
error: no example target named 'unknown'.
```

### `console_error_code code message`

Print a **red** `error[CODE]:` prefix followed by the message to stderr.
Used for structured error codes (e.g. `E0583`).

```bash
console_error_code "E0583" "file not found for module 'mymodule'"
```

Output:
```
error[E0583]: file not found for module 'mymodule'
```

## VERBOSE and QUIET

| Variable | Effect |
|----------|--------|
| `QUIET=1` | Suppresses all `console_print`-based output (`console_log`, `console_status`, `console_warning`, `console_info`) |
| `VERBOSE=0` | `console_info` output is hidden |
| `VERBOSE≥1` | `console_info` output is shown |

`console_error`, `console_error_code`, and `console_hint` always print to
stderr regardless of `QUIET`.

## Platform notes

The escape sequence prefix is automatically set to `\x1B` on macOS (Darwin)
and `\e` on Linux, so colors work correctly on both platforms.

## License

MIT
