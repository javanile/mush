---
layout: default
title: module
nav_order: 1
parent: Code Reference
compliance: 1
---

# The 'module' keyword

The `module` keyword load a module, which encapsulates code and allows for modularity.

Example:

```shell
## File: src/main.sh
module my_utils

main() {
    my_utils_print "Hello, world!"
} 
```

```shell
## File: src/my_utils.sh

my_utils_print() {
    echo "$1"
}
```

A module in Mush can take one of two forms: it can be a single file,
in which case the module is named after the file itself, or it can be a folder containing a file named module.sh.
In the latter case, the name of the module is derived from the name of the folder containing the module.sh file.
This flexibility allows for a straightforward organization of code,
accommodating both single-file and multi-file module structures. See the example below:

```shell
## File: src/main.sh

module my_utils

main() {
    my_utils_print "Hello, world!"
} 
```

```shell
## File: src/my_utils/module.sh

my_utils_print() {
    echo "$1"
}
```

When a module is represented by a folder, the individual .sh files contained within that folder are referred to as 'submodules'.
This organizational structure allows for a logical grouping of code into separate files within the module, promoting modularity and codebase organization.

### Reference

- https://doc.rust-lang.org/std/primitive.array.html
