---
layout: default
title: extern package
permalink: /reference/extern-package/
nav_order: 3
parent: Code Reference
compliance: 1
---

# The 'extern package' keyword

The `extern package` keyword specifies an external package or dependency to be used.

Example:

```shell
## File: src/main.sh
extern package my_extern_package

main() {
  my_package_print "Hello, world!"
}
```

```toml
## File: Manifest.toml
[packages]
name = "my_package"
version = "0.1.0"

[dependencies]
my_extern_package = "0.1.0"
```
