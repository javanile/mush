---
layout: default
title: mush
permalink: /commands/mush/
parent: General
nav_order: 01
---

# mush

## NAME

mush --- The shell package manager

## SYNOPSIS

```console
mush [OPTIONS] COMMAND [ARGS]
mush [OPTIONS] --version
mush [OPTIONS] --list
mush [OPTIONS] --help
mush [OPTIONS] --explain CODE
```

## DESCRIPTION

This program is a package manager and build tool for the shell scripting language.

## COMMANDS

### Build commands

<!--
[cargo-bench(1)](cargo-bench.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Execute benchmarks of a package.
-->

[mush build](/commands/build/)\
&nbsp;&nbsp;&nbsp;&nbsp;Compile a package.

[mush check](/commands/check)\
&nbsp;&nbsp;&nbsp;&nbsp;Check a local package and all of its dependencies for errors.

<!--
[cargo-clean(1)](cargo-clean.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Remove artifacts that Cargo has generated in the past.

[cargo-doc(1)](cargo-doc.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Build a package's documentation.

[cargo-fetch(1)](cargo-fetch.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Fetch dependencies of a package from the network.

[cargo-fix(1)](cargo-fix.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Automatically fix lint warnings reported by rustc.
--->

[mush run](/commands/run/)\
&nbsp;&nbsp;&nbsp;&nbsp;Run a binary or example of the local package.

<!--
[cargo-rustc(1)](cargo-rustc.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Compile a package, and pass extra options to the compiler.

[cargo-rustdoc(1)](cargo-rustdoc.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Build a package's documentation, using specified custom flags.

[cargo-test(1)](cargo-test.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Execute unit and integration tests of a package.

### Manifest Commands

[cargo-generate-lockfile(1)](cargo-generate-lockfile.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Generate `Cargo.lock` for a project.

[cargo-locate-project(1)](cargo-locate-project.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Print a JSON representation of a `Cargo.toml` file's location.

[cargo-metadata(1)](cargo-metadata.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Output the resolved dependencies of a package in machine-readable format.

[cargo-pkgid(1)](cargo-pkgid.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Print a fully qualified package specification.

[cargo-tree(1)](cargo-tree.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Display a tree visualization of a dependency graph.

[cargo-update(1)](cargo-update.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Update dependencies as recorded in the local lock file.

[cargo-vendor(1)](cargo-vendor.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Vendor all dependencies locally.

[cargo-verify-project(1)](cargo-verify-project.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Check correctness of crate manifest.
--->

### Package Commands

[mush init](/commands/init/)\
&nbsp;&nbsp;&nbsp;&nbsp;Create a new Mush package in an existing directory.

[mush install](/commands/install/)\
&nbsp;&nbsp;&nbsp;&nbsp;Build and install a Mush binary.

[mush new](/commands/new/)\
&nbsp;&nbsp;&nbsp;&nbsp;Create a new Mush package.

<!--
[cargo-search(1)](cargo-search.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Search packages in crates.io.

[cargo-uninstall(1)](cargo-uninstall.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Remove a Rust binary.
-->

### Publishing Commands

<!--
[cargo-login(1)](cargo-login.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Save an API token from the registry locally.

[cargo-logout(1)](cargo-logout.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Remove an API token from the registry locally.

[cargo-owner(1)](cargo-owner.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Manage the owners of a crate on the registry.

[cargo-package(1)](cargo-package.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Assemble the local package into a distributable tarball.
-->

[cargo-publish(1)](cargo-publish.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Upload a package to the registry.

<!--
[cargo-yank(1)](cargo-yank.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Remove a pushed crate from the index.

### General Commands

[cargo-help(1)](cargo-help.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Display help information about Cargo.

[cargo-version(1)](cargo-version.html)\
&nbsp;&nbsp;&nbsp;&nbsp;Show version information.

-->

## OPTIONS

### Special Options

|                    |                                                                                                                    |
|-------------------:|--------------------------------------------------------------------------------------------------------------------|
|  `-V`, `--version` | Print version info and exit. If used with `--verbose`, prints extra information.                                   |
|           `--list` | List all installed Cargo subcommands. If used with `--verbose`, prints extra information.                          |
| `--explain` *code* | Run `rustc --explain CODE` which will print out a detailed explanation of an error message (for example, `E0004`). |
{: .options-table }

### Display Options

|                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
|---------------------------------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                `-v`. `--verbose` | Use verbose output. May be specified twice for “very verbose” output which includes extra output such as dependency warnings and build script output. May also be specified with the `term.verbose` [config value](../reference/config.html).                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|                  `-q`, `--quiet` | Do not print cargo log messages. May also be specified with the `term.quiet` [config value](../reference/config.html).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
|                 `--color` *when* | Control when colored output is used. Valid values: - `auto` (default): Automatically detect if color support is available on the terminal. - `always`: Always display colors. - `never`: Never display colors. May also be specified with the `term.color` [config value](../reference/config.html).                                                                                                                                                                                                                                                                                                                                                                                        |
|                       `--frozen` | Either of these flags requires that the `Cargo.lock` file is up-to-date. If the lock file is missing, or it needs to be updated, Cargo will exit with an error. The `--frozen` flag also prevents Cargo from attempting to access the network to determine if it is out-of-date. These may be used in environments where you want to assert that the `Cargo.lock` file is up-to-date (such as a CI build) or want to avoid network access.                                                                                                                                                                                                                                                  |
|                       `--locked` | Either of these flags requires that the `Cargo.lock` file is up-to-date. If the lock file is missing, or it needs to be updated, Cargo will exit with an error. The `--frozen` flag also prevents Cargo from attempting to access the network to determine if it is out-of-date. These may be used in environments where you want to assert that the `Cargo.lock` file is up-to-date (such as a CI build) or want to avoid network access.                                                                                                                                                                                                                                                  |
|                      `--offline` | Prevents Cargo from accessing the network for any reason. Without this flag, Cargo will stop with an error if it needs to access the network and the network is not available. With this flag, Cargo will attempt to proceed without the network if possible. Beware that this may result in different dependency resolution than online mode. Cargo will restrict itself to crates that are downloaded locally, even if there might be a newer version as indicated in the local copy of the index. See the [cargo-fetch(1)](cargo-fetch(1)) command to download dependencies before going offline. May also be specified with the `net.offline` [config value](../reference/config.html). |
|                     `+toolchain` | If Cargo has been installed with rustup, and the first argument to `cargo` begins with `+`, it will be interpreted as a rustup toolchain name (such as +stable or +nightly). See the [rustup documentation](https://rust-lang.github.io/rustup/overrides.html) for more information about how toolchain overrides work.                                                                                                                                                                                                                                                                                                                                                                     |
| `--config` *KEY=VALUE* or *PATH* | Overrides a Cargo configuration value. The argument should be in TOML syntax of *KEY=VALUE*, or provided as a path to an extra configuration file. This flag may be specified multiple times. See the [command-line overrides section](../reference/config.html#command-line-overrides) for more information.                                                                                                                                                                                                                                                                                                                                                                               |
|                      `-C` *PATH* | Changes the current working directory before executing any specified operations. This affects things like where cargo looks by default for the project manifest (Cargo.toml), as well as the directories searched for discovering .cargo/config.toml, for example. This option must appear before the command name, for example cargo -C path/to/my-project build. This option is only available on the [nightly channel](https://doc.rust-lang.org/book/appendix-07-nightly-rust.html) and requires the -Z unstable-options flag to enable (see #10098).                                                                                                                                   |
|                   `-h`, `--help` | Prints help information.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|                      `-Z` *flag* | Unstable (nightly-only) flags to Cargo. Run cargo -Z help for details.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
{: .options-table }


## ENVIRONMENT

See [the reference](../reference/environment-variables.html) for
details on environment variables that Cargo reads.


## EXIT STATUS

* `0` - Mush succeeded.
* `101` - Mush failed to complete.


## FILES

`~/.mush/`\
&nbsp;&nbsp;&nbsp;&nbsp;Default location for Cargo's "home" directory where it
stores various files. The location can be changed with the `$MUSH_HOME`
environment variable.

`$CARGO_HOME/bin/`\
&nbsp;&nbsp;&nbsp;&nbsp;Binaries installed by [mush install](cargo-install.html) will be located here. If using
[rustup], executables distributed with Rust are also located here.

<!----
`$CARGO_HOME/config.toml`\
&nbsp;&nbsp;&nbsp;&nbsp;The global configuration file. See [the reference](../reference/config.html)
for more information about configuration files.

`.cargo/config.toml`\
&nbsp;&nbsp;&nbsp;&nbsp;Cargo automatically searches for a file named `.cargo/config.toml` in the
current directory, and all parent directories. These configuration files
will be merged with the global configuration file.

`$CARGO_HOME/credentials.toml`\
&nbsp;&nbsp;&nbsp;&nbsp;Private authentication information for logging in to a registry.
------>

`$CARGO_HOME/registry/`\
&nbsp;&nbsp;&nbsp;&nbsp;This directory contains cached downloads of the registry index and any
downloaded dependencies.

`$CARGO_HOME/git/`\
&nbsp;&nbsp;&nbsp;&nbsp;This directory contains cached downloads of git dependencies.

Please note that the internal structure of the `$MUSH_HOME` directory is not
stable yet and may be subject to change.

## EXAMPLES

1. Build a local package and all of its dependencies:

       mush build

2. Build a package with optimizations:

       mush build --release

3. Run tests for a cross-compiled target:

       mush test --target zsh

4. Create a new package that builds an executable:

       mush new foobar

5. Create a package in the current directory:

       mkdir foo && cd foo
       mush init .

6. Learn about a command's options and usage:

       mush --help install

## BUGS

See <https://github.com/javanile/mush/issues> for issues.

## SEE ALSO

[The Manifest File](/manifest/), [Environment Variables](/environment-variables/)
````