---
layout: default
title: Code Reference
nav_order: 04
has_children: true
has_toc: false
---

# Code Reference

Mush is a versatile and extensible tool that serves as a wrapper for shell scripting languages, 
designed to facilitate the organization and construction of codebases. 
While Mush allows for the use of any shell script practices, it provides specific keywords 
for loading files and linking the final artifact, which will be built. 
Mush is also extendable through plugins, allowing customization of language rules and build processes.

## File Organization

Mush scripts (.sh files) are free from specific constraints, 
allowing the use of typical shell scripting practices. 
However, for better codebase organization, Mush encourages the use of Mush-specific keywords 
for loading files and linking the final artifact.

## Keywords

### `module`

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

### `public`

The `public` keyword marks submodule as accessible from outside the module.

Example:

```shell
## File: src/main.sh

module my_utils

main() {
  my_utils_print "Hello, world!"
}
```

```shell
## File: src/my_utils/module.sh

public my_submodule_utils
```

```shell
## File: src/my_utils/my_submodule_utils.sh

my_utils_print() {
    echo "$1"
}
```

### `extern package`

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

### `use`

The `use` keyword is reserved for plugins development.

### `embed`

The `embed` keyword includes external files or resources into the Mush codebase.

Example:
```mush
embed "resource.js"
```

### `legacy`

The `legacy` keyword allows backward compatibility with traditional shell scripting practices.

Example:

```mush
legacy {
  // Legacy shell script code here
}
```

## Extensibility with Plugins

Mush can be extended by writing plugins, enabling you to customize language rules and build processes to meet specific project requirements.
For more information on writing plugins and extending Mush, please refer to the Mush documentation.

## Conclusion

Mush provides a set of keywords to help organize codebases and manage dependencies efficiently. 
It combines the flexibility of shell scripting with the benefits of a modular, 
extensible approach to code organization and building.
