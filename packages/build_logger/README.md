# build_logger

A mush build plugin that hooks into the build pipeline and dumps all
`MUSH_*` environment variables to stdout. Useful for debugging the mush
build context.

## How it works

`build_logger` implements the `__feature_build_logger_hook_build` hook.
When this plugin is installed, mush calls this hook during the build step,
printing all variables whose names start with `MUSH_` via `declare -p`.

```
Variables:
declare -- MUSH_PACKAGE_NAME="mypackage"
declare -- MUSH_PACKAGE_VERSION="0.1.0"
declare -- MUSH_TARGET_PATH="target/debug"
...
```

## Installation

```toml
[dependencies]
build_logger = "mush build_logger"
```

## Status

Early-stage utility package. Primarily intended for mush core development
and debugging build pipelines.
