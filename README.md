# 🍄 Mush

[![Build Status](https://travis-ci.com/javanile/pipetest.svg?branch=main)](https://travis-ci.com/javanile/pipetest)
[![License](https://img.shields.io/github/license/javanile/mush.svg)](https://github.com/javanile/mush/blob/main/LICENSE)

Mush is the shell package builder. Mush downloads your shell package’s dependencies, compiles your packages, makes distributable packages, and uploads them to GitHub, as public community’s package registry.

> This project is mostly inspired by Rust and Cargo!

## Suppoerted Shells

We try to do everything possible to ensure maximum compatibility with these platforms

[![bash](https://img.shields.io/badge/bash-&ge;2.03-lightgrey.svg?style=flat)](https://www.gnu.org/software/bash/)
[![bosh](https://img.shields.io/badge/bosh-&ge;2018%2F10%2F07-lightgrey.svg?style=flat)](http://schilytools.sourceforge.net/bosh.html)
[![busybox](https://img.shields.io/badge/busybox-&ge;1.20.0-lightgrey.svg?style=flat)](https://www.busybox.net/)
[![dash](https://img.shields.io/badge/dash-&ge;0.5.4-lightgrey.svg?style=flat)](http://gondor.apana.org.au/~herbert/dash/)
[![ksh](https://img.shields.io/badge/ksh-&ge;93s-lightgrey.svg?style=flat)](http://kornshell.org)
[![mksh](https://img.shields.io/badge/mksh-&ge;R28-lightgrey.svg?style=flat)](http://www.mirbsd.org/mksh.htm)
[![posh](https://img.shields.io/badge/posh-&ge;0.3.14-lightgrey.svg?style=flat)](https://salsa.debian.org/clint/posh)
[![yash](https://img.shields.io/badge/yash-&ge;2.29-lightgrey.svg?style=flat)](https://yash.osdn.jp/)
[![zsh](https://img.shields.io/badge/zsh-&ge;3.1.9-lightgrey.svg?style=flat)](https://www.zsh.org/)

## Documentation

To start using Mush, learn more at the [Mush website](https://mush.javanile.org).

## Demo

[![mush](https://asciinema.org/a/401463.svg)](https://asciinema.org/a/401463)

## Try it now

Create a new demo package on your system with the following command

```shell
curl https://mush.javanile.org/demo | bash
```

Add your custom code to `src/main.sh` or `src/utils/module.sh` files and run it with

```shell
cd demo && ./bin/mush run 
```

In case you are ready to release your package, run

```shell
cd demo && ./bin/mush build --release
```

## Cheat Sheet

... TODO

## Contributing

See [CONTRIBUTING.md in the repo](https://github.com/javanile/mush/blob/main/CONTRIBUTING.md), obviously pull-request are welcome.

## Community & Questions

- [GitHub Issues](https://github.com/javanile/mush/issues): report a bug or raise a feature request to the Mush core team
- [StackOverflow Tag](https://stackoverflow.com/questions/tagged/bash+unit-testing): see existing Q&A for `BASH` and `Unit Testing`. We look at them often

## License

Mush is open-sourced software licensed under the [MIT license](LICENSE.md).
