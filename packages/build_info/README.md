# build_info

> **Status: placeholder** — the library is empty and not yet implemented.

Planned package for injecting build-time metadata (package name, version,
build date, git commit) into compiled mush artifacts as shell variables.

## Intended usage (future)

```toml
[dependencies]
build_info = "mush build_info"
```

```bash
extern package build_info

main() {
  echo "Version: ${BUILD_INFO_VERSION}"
  echo "Built:   ${BUILD_INFO_DATE}"
}
```
