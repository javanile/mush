# platform

> **Status: placeholder** — the library is empty and not yet implemented.

Planned package for OS and shell platform detection. Will provide helper
functions to write portable shell scripts that behave correctly across
Linux, macOS, and other platforms.

## Intended usage (future)

```toml
[dependencies]
platform = "mush platform"
```

```bash
extern package platform

main() {
  if platform_is_macos; then
    echo "Running on macOS"
  elif platform_is_linux; then
    echo "Running on Linux"
  fi
}
```

A `tests/platform-test.sh` file is present but the library functions are not
yet implemented.
