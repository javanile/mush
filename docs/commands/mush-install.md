---
layout: default
title: mush install
parent: CLI Commands
nav_order: 31
---

# mush install

## NAME
cargo-init - Create a new Cargo package in an existing directory

## SYNOPSIS
cargo init [options] [path]

## DESCRIPTION
This command will create a new Cargo manifest in the current directory. Give a path as an argument to create in the given directory.

If there are typically-named Rust source files already in the directory, those will be used. If not, then a sample src/main.rs file will be created, or src/lib.rs if --lib is passed.

If the directory is not already in a VCS repository, then a new repository is created (see --vcs below).

See cargo-new(1) for a similar command which will create a new package in a new directory.

## OPTIONS
Init Options
--bin
Create a package with a binary target (src/main.rs). This is the default behavior.
--lib
Create a package with a library target (src/lib.rs).
--edition edition
Specify the Rust edition to use. Default is 2021. Possible values: 2015, 2018, 2021
--name name
Set the package name. Defaults to the directory name.
--vcs vcs
Initialize a new VCS repository for the given version control system (git, hg, pijul, or fossil) or do not initialize any version control at all (none). If not specified, defaults to git or the configuration value cargo-new.vcs, or none if already inside a VCS repository.
--registry registry
This sets the publish field in Cargo.toml to the given registry name which will restrict publishing only to that registry.
Registry names are defined in Cargo config files. If not specified, the default registry defined by the registry.default config key is used. If the default registry is not set and --registry is not used, the publish field will not be set which means that publishing will not be restricted.

### Display Options
-v
--verbose
Use verbose output. May be specified twice for "very verbose" output which includes extra output such as dependency warnings and build script output. May also be specified with the term.verbose config value.
-q
--quiet
Do not print cargo log messages. May also be specified with the term.quiet config value.
--color when
Control when colored output is used. Valid values:
auto (default): Automatically detect if color support is available on the terminal.
always: Always display colors.
never: Never display colors.
May also be specified with the term.color config value.

### Common Options
+toolchain
If Cargo has been installed with rustup, and the first argument to cargo begins with +, it will be interpreted as a rustup toolchain name (such as +stable or +nightly). See the rustup documentation for more information about how toolchain overrides work.
--config KEY=VALUE or PATH
Overrides a Cargo configuration value. The argument should be in TOML syntax of KEY=VALUE, or provided as a path to an extra configuration file. This flag may be specified multiple times. See the command-line overrides section for more information.
-h
--help
Prints help information.
-Z flag
Unstable (nightly-only) flags to Cargo. Run cargo -Z help for details.

## ENVIRONMENT
See the reference for details on environment variables that Cargo reads.

## EXIT STATUS
0: Cargo succeeded.
101: Cargo failed to complete.
EXAMPLES
Create a binary Cargo package in the current directory:

cargo init

## SEE ALSO
cargo(1), cargo-new(1)