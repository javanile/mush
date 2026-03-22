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

mush is a package manager and build tool for the shell scripting language. It
manages packages declared in a `Manifest.toml` file, compiles shell sources
into self-contained executables, and resolves both mush and system
dependencies.

## COMMANDS

### Build Commands

[mush build](/commands/mush-build/)\
&nbsp;&nbsp;&nbsp;&nbsp;Compile a package.

[mush check](/commands/mush-check/)\
&nbsp;&nbsp;&nbsp;&nbsp;Check a local package and all of its dependencies for errors.

[mush run](/commands/mush-run/)\
&nbsp;&nbsp;&nbsp;&nbsp;Run a binary or example of the local package.

### Package Commands

[mush init](/commands/mush-init/)\
&nbsp;&nbsp;&nbsp;&nbsp;Create a new mush package in an existing directory.

[mush install](/commands/mush-install/)\
&nbsp;&nbsp;&nbsp;&nbsp;Build and install a mush package.

[mush new](/commands/mush-new/)\
&nbsp;&nbsp;&nbsp;&nbsp;Create a new mush package in a new directory.

### Manifest Commands

[mush legacy](/commands/mush-legacy/)\
&nbsp;&nbsp;&nbsp;&nbsp;Download and register a legacy shell dependency.

### Publishing Commands

[mush publish](/commands/mush-publish/)\
&nbsp;&nbsp;&nbsp;&nbsp;Upload a package to the registry.

## OPTIONS

### Special Options

|                    |                                                                                          |
|-------------------:|------------------------------------------------------------------------------------------|
|  `-V`, `--version` | Print version info and exit.                                                             |
|           `--list` | List all installed mush subcommands.                                                     |
| `--explain` *code* | Print a detailed explanation of an error code (for example, `E0583`).                   |
{: .options-table }

### Display Options

|                  |                                                                                           |
|-----------------:|-------------------------------------------------------------------------------------------|
| `-v`, `--verbose` | Use verbose output. Repeat to increase level (`-vv`, `-vvv`, etc.).                      |
|   `-q`, `--quiet` | Suppress mush log messages.                                                               |
|   `-h`, `--help`  | Print help information.                                                                   |
{: .options-table }


## ENVIRONMENT

See [Environment Variables](/environment-variables/) for details on environment
variables that mush reads.


## EXIT STATUS

* `0` — mush succeeded.
* `101` — mush failed to complete.


## FILES

`~/.mush/`\
&nbsp;&nbsp;&nbsp;&nbsp;Default location for mush's home directory. Can be changed with
the `$MUSH_HOME` environment variable.

`~/.mush/bin/`\
&nbsp;&nbsp;&nbsp;&nbsp;Binaries installed by `mush install` are placed here.

`~/.mush/registry/`\
&nbsp;&nbsp;&nbsp;&nbsp;Cached downloads of registry index and package sources.


## EXAMPLES

1. Build the local package:

       mush build

2. Build with optimizations:

       mush build --release

3. Create a new package:

       mush new mypackage

4. Create a package in the current directory:

       mkdir foo && cd foo
       mush init

5. Install a package by name:

       mush install ripgrep

6. Learn about a command:

       mush help build

## BUGS

See <https://github.com/javanile/mush/issues> for issues.

## SEE ALSO

[The Manifest File](/manifest/), [Environment Variables](/environment-variables/)
