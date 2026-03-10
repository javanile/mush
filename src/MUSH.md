# Mush - Shell Package Manager

> Mush is inspired by Rust and Cargo as developer experience: it brings structured modules, a manifest file, and a build pipeline to shell scripting. The `target/` directory contains all build outputs (debug builds in `target/debug/`, release builds in `target/release/`).

## Project Structure
- `Manifest.toml` - package manifest (name, version, edition, dependencies)
- `src/main.sh` - entry point with `main()` function
- `src/<module>.sh` - single-file modules
- `src/<module>/module.sh` - folder modules with submodules

## Keywords
- `module <name>` - load a module from src/
- `public <name>` - expose a submodule outside its parent module
- `extern package <name>` - declare external dependency
- `embed <name>` - embed module source in the final binary
- `inject file <name>` / `inject env <VAR>` - inject files or env vars at build time
- `legacy` - backward compatibility with traditional shell scripting

## Coding Style
- `local` only declares a variable; assignment must be on a separate line — `local x; x="$1"` not `local x="$1"` — because `local` swallows the exit code and silently breaks `set -e`

## Naming Convention
Functions follow the pattern: `<projectname>_<modulename>_<functionname>`
- Variables: lowercase snake_case (e.g. `my_variable`)
- Constants: UPPERCASE (e.g. `PI=3.14`)
- Functions: snake_case (e.g. `my_function`)

## Commands
- `mush new <name>` - create new project
- `mush init` - init project in existing directory
- `mush build` - build debug binary to target/debug/
- `mush build --release` - build release binary
- `mush run` - build and run

## Manifest.toml
- [package] section: name, version (semver), edition ("2022")
- [dependencies] section: `package_name = "version_constraint"`
