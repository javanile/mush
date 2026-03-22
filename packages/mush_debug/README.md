# mush_debug

> **Status: stub** — this package is a placeholder and not yet implemented.

Planned binary utility for inspecting mush debug artifacts and build state
at runtime. The `mush_debug` binary will expose helpers that compiled debug
entrypoints can call to retrieve runtime context (current file, current line,
package root, etc.).

## Intended usage (future)

```bash
# Inside an example or binary built in debug mode:
main() {
  code_dumper "$(mush_debug file)" "$(mush_debug line)" "keyword" "message"
}
```

The current `src/main.sh` is a hello-world stub. The `Manifest.toml` name
also needs to be corrected to `mush_debug`.
