---
layout: default
title: Get Started
permalink: /
nav_order: 01
compliance: 1
---

# Mush

![Huge Amount of Mud](assets/img/memes/meme-02.jpg)

Mush is the shell package builder. Mush downloads your shell package's dependencies, 
compiles your packages, makes distributable packages, and uploads them to GitHub, 
as public community’s package registry. You can contribute to this project on GitHub.

> This project is mostly inspired by Rust and Cargo!

## Get Started

The easiest way to get Mush is to install the current stable release from GitHub by using curl.
Installing Mush using curl will also create a directory at `$HOME/.mush/bin` where you can host the scripts you'll install subsequently.

On Linux and macOS systems, this is done as follows:

```console
$ curl get.javanile.org/mush | sh
```

## First Steps with Mush

This section provides a quick sense for the `mush` command line tool. We
demonstrate its ability to generate a new package for us,
its ability to compile the shell binary within the package, and
its ability to run the resulting program.

To start a new package with Mush, use `mush new`:

```console
$ mush new hello_world
```

Mush defaults to `--bin` to make a binary program. To make a library, we
would pass `--lib`, instead.

Let’s check out what Mush has generated for us:

```console
$ cd hello_world
$ tree .
.
├── Manifest.toml
└── src
    └── main.sh

1 directory, 2 files
```

This is all we need to get started. First, let’s check out `Manifest.toml`:

```toml
[package]
name = "hello_world"
version = "0.1.0"
edition = "2022"

[dependencies]
```

This is called a [**manifest**](/manifest/), and it contains all of the
metadata that Mush needs to compile your package.

Here’s what’s in `src/main.sh`:

```shell
main() {
    echo "Hello, world!"
}
```

Mush generated a "hello world" program for us, otherwise known as a
binary. Let’s compile it:

```console
$ mush build
   Compiling hello_world v0.1.0 (file:///path/to/package/hello_world)
```

And then run it:

```console
$ ./target/debug/hello_world
Hello, world!
```

We can also use `mush run` to compile and then run it, all in one step:

```console
$ mush run
     Fresh hello_world v0.1.0 (file:///path/to/package/hello_world)
   Running `target/hello_world`
Hello, world!
```

## Going further

For more details on using Mush, check out the [CLI Commands](/commands/)
