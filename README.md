<div align="center">

# 🎉 **Exciting News - Release 0.2.0 on March 14, 2024!** 🎉

</div>

Dear users and enthusiasts of our project,

We are thrilled to announce that the release 0.2.0 of our project is on its way, and there's a special reason to celebrate it! 🚀

✨ **Release Date:** March 14th, on **Pi Day** (3.14) 🥳

This update will bring a slew of new features, improvements, and bug fixes, and we can't wait to share it with you.

Keep an eye on this repository for further details on the new features and upgrade instructions.

Thank you for your ongoing support and for being a part of our community. We look forward to celebrating with you on Pi Day! 🎈

Stay tuned!

---

# 🍄 Mush

[![Build Status](https://travis-ci.com/javanile/pipetest.svg?branch=main)](https://travis-ci.com/javanile/pipetest)
[![License](https://img.shields.io/github/license/javanile/mush.svg)](https://github.com/javanile/mush/blob/main/LICENSE)

Mush is the shell package builder. Mush downloads your shell package’s dependencies, compiles your packages, makes distributable packages, and uploads them to GitHub, as public community’s package registry.

> This project is mostly inspired by Rust and Cargo!

## Supported Shells

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

[![mush](https://raw.githubusercontent.com/francescobianco/ghostplay-demos/main/demos/mush/demo.gif)](https://raw.githubusercontent.com/francescobianco/ghostplay-demos/main/demos/mush/demo.gif)

## Local Demo

Create a new demo package on your system with the following command

```shell
curl https://mush.javanile.org/demo | bash
```

Add your custom code to `src/main.sh` or `src/utils/module.sh` files then run it with

```shell
cd demo && ./bin/mush run 
```

In case you are ready to release your package, type the following command

```shell
cd demo && ./bin/mush build --release
```

## Cheat Sheet

TODO...

## Contributing

See [CONTRIBUTING.md in the repo](https://github.com/javanile/mush/blob/main/CONTRIBUTING.md), obviously pull-request are welcome.

## Community & Questions

- [GitHub Issues](https://github.com/javanile/mush/issues): report a bug or raise a feature request to the Mush core team
- [StackOverflow Tag](https://stackoverflow.com/questions/tagged/bash+unit-testing): see existing Q&A for `BASH` and `Unit Testing`. We look at them often

## License

Mush is open-sourced software licensed under the [MIT license](LICENSE.md).
