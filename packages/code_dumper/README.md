# code_dumper

Renders Rust-style source code error annotations in the terminal. Given a
file, a line number, and a keyword, `code_dumper` prints a formatted
diagnostic pointing to the exact column where the issue occurs — arrows,
underlines and all.

## Installation

```toml
[dependencies]
code_dumper = "mush code_dumper"
```

```bash
extern package code_dumper
```

## Function

### `code_dumper file line keyword message [help]`

| Parameter | Description |
|-----------|-------------|
| `file` | Path to the source file |
| `line` | Line number where the error occurs |
| `keyword` | Token in the source line to underline |
| `message` | Error message to display next to the underline |
| `help` | Optional help hint shown below the annotation |

```bash
code_dumper "src/main.sh" "12" "unknown_fn" "function not found" \
  "did you forget to import the module?"
```

Output:
```
   --> src/main.sh:12:4
    |
12  | unknown_fn arg1
    | ^^^^^^^^^^ function not found
    |
    = help: did you forget to import the module?
```

## Example

See `examples/demo.sh` for a runnable demonstration:

```bash
mush run --example demo
```
