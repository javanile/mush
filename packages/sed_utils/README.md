# sed_utils

A collection of `sed`-based text processing utilities for mush packages,
organized in four modules: `basic`, `advanced`, `extraction`, and `format`.

## Installation

```toml
[dependencies]
sed_utils = "mush sed_utils"
```

```bash
extern package sed_utils
```

## Modules and functions

### `basic`

| Function | Signature | Description |
|----------|-----------|-------------|
| `sed_remove_blank_lines` | `input output` | Remove all blank/whitespace-only lines |
| `sed_remove_comments` | `input output` | Remove lines starting with `#` |
| `sed_replace_string` | `input search replace output` | Replace all occurrences of a string |
| `sed_replace_line` | `input pattern replacement output` | Replace entire lines matching a pattern |

### `advanced`

| Function | Signature | Description |
|----------|-----------|-------------|
| `sed_insert_before` | `input pattern line output` | Insert a line before every matching line |
| `sed_insert_after` | `input pattern line output` | Insert a line after every matching line |
| `sed_delete_lines` | `input pattern output` | Delete all lines matching a pattern |

### `extraction`

| Function | Signature | Description |
|----------|-----------|-------------|
| `sed_extract_lines` | `input pattern output` | Extract lines matching a pattern |
| `sed_extract_between` | `input start end output` | Extract lines between two patterns (inclusive) |

### `format`

| Function | Signature | Description |
|----------|-----------|-------------|
| `sed_wrap_lines` | `input prefix suffix output` | Wrap each line with a prefix and suffix |
| `sed_indent_lines` | `input spaces output` | Indent each line by N spaces |
| `sed_align_columns` | `input output` | Align columns separated by whitespace |

## Example

```bash
extern package sed_utils

main() {
  # Remove blank lines and comments from a config file
  sed_remove_blank_lines "config.conf" "/tmp/clean.conf"
  sed_remove_comments "/tmp/clean.conf" "/tmp/final.conf"

  # Insert a header before every section marker
  sed_insert_before "/tmp/final.conf" "^\[" "# --- section ---" "/tmp/annotated.conf"
}
```

See `examples/demo.sh` for a runnable demonstration covering all functions:

```bash
mush run --example demo
```

## License

MIT
