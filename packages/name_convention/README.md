# name_convention

A mush plugin that enforces naming conventions for functions defined in your
package's source files. It runs as a compile-time hook and reports violations
with Rust-style diagnostics, including the exact line, a caret underline, and
a suggested rename.

## Installation

Add it as a dev-dependency from the `develop` branch:

```
mush add name_convention@develop --dev
```

This updates your `Manifest.toml` and downloads the plugin into your project.
The plugin is a dev-dependency because it only runs during compilation — it is
not shipped in the final binary.

## Activation

Installation alone does not activate the plugin. You must explicitly enable it
by adding the feature flag to your `Manifest.toml`:

```toml
[features]
name_convention = true
```

Add this section (or the line) by hand after running `mush add`. Once the flag
is present, the plugin fires automatically on every `mush build`.

## Convention rules

The required prefix for each function depends on the source file it lives in:

| Source file              | Required prefix          |
|--------------------------|--------------------------|
| `src/main.sh`            | `<package>_`             |
| `src/lib.sh`             | `<package>_`             |
| `src/pluto.sh`           | `<package>_pluto_`       |
| `src/pluto/module.sh`    | `<package>_pluto_`       |

Functions prefixed with `__` and the bare `main` entrypoint are exempt.

## Example error output

```
error[E0100]: function greet violates naming convention
   --> src/main.sh:5
    |
  5 | greet() {
    | ^^^^^ function must start with greeting_
    |
    = help: rename to greeting_greet
```

## Example `Manifest.toml`

```toml
[package]
name = "greeting"
version = "0.1.0"
edition = "2022"

[features]
name_convention = true

[dev-dependencies]
name_convention = "mush name_convention develop"
```
