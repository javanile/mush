<div align="center">

# 🎉 **Exciting News** 🎉<br>**Release 0.3.0 on March 14, 2026!** 

</div>

Dear users and enthusiasts of our project,

We are thrilled to announce that the release 0.3.0 of our project is on its way, and there's a special reason to celebrate it! 🚀

✨ **Release Date:** March 14th, on **Pi Day** (3.14) 🥳

This update will bring a slew of new features, improvements, and bug fixes, and we can't wait to share it with you.

Keep an eye on this repository for further details on the new features and upgrade instructions.

Thank you for your ongoing support and for being a part of our community. We look forward to celebrating with you on Pi Day! 🎈

Stay tuned!

---

<div align="center">


<a href="https://www.javanile.org/hackathon/">
<img src="https://raw.githubusercontent.com/javanile/hackathon/refs/heads/main/assets/images/devops-hackathon-banner.svg" />
</a>


</div>

---


# 🍄 Mush

[![autobuild](https://github.com/javanile/mush/actions/workflows/autobuild.yml/badge.svg)](https://github.com/javanile/mush/actions/workflows/autobuild.yml)
[![ShellCheck](https://github.com/javanile/mush/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/javanile/mush/actions/workflows/shellcheck.yml)

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

This cheatsheet provides an overview of essential keywords used in the Mush scripting language and their purposes.

- **`module`**: Loads a module, encapsulating code and allowing for modularity. A module can be a single file or a folder containing a `module.sh` file.

- **`public`**: Marks a submodule as accessible from outside the module.

- **`extern package`**: Specifies an external package or dependency to be used.

- **`embed`**: Includes external files or resources into the Mush codebase.

For further details, please consult the [Reference documentation](https://mush.javanile.org/reference/).


## Contributing

See [CONTRIBUTING.md in the repo](https://github.com/javanile/mush/blob/main/CONTRIBUTING.md), obviously pull-request are welcome.

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Francesco Bianco via bianco@javanile.org. All security vulnerabilities will be promptly addressed.

## Community & Questions

To interact with us, you can find us in the following ways:

- [GitHub Issues](https://github.com/javanile/mush/issues): Report a bug or raise a feature request to the Mush core team
- [Mush on Discord](https://discord.com/invite/SVx7JHjAcY): Join the `#mush` channel on the Javanile Discord community 
- [StackOverflow Tag](https://stackoverflow.com/questions/tagged/bash+unit-testing): See existing Q&A for `BASH` and `Unit Testing`. We look at them often

## Acknowledgements

I would like to express my sincere gratitude to those who have contributed to maintaining the idea that Bash and all shell languages are proper programming languages, deserving to be treated with the appropriate tools.

Special thanks to:

**Joseph Werle** ([@jwerle](https://github.com/jwerle)) and **Ben Peachey** ([@Potherca](https://github.com/Potherca)) for their outstanding work in maintaining BPKG and for their contribution in supporting the Bash ecosystem, demonstrating that shell languages deserve the same dignity as other programming languages.

A special acknowledgement goes to **Koichi Nakashima** ([@ko1nksm](https://github.com/ko1nksm)), not only for his pioneering work on ShellSpec, but also for his determination and willingness to keep the world of shell languages at the cutting edge. His vision has shown that these languages are full of possibilities and without effective limitations.

Thanks to their commitment, the shell languages community continues to thrive and evolve, providing developers with powerful and elegant tools to solve complex problems.

## License

Mush is open-sourced software licensed under the [MIT license](LICENSE.md).
