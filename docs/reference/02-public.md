---
layout: default
title: public
nav_order: 2
parent: Code Reference
compliance: 1
---

# The 'public' keyword

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
