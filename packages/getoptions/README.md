# getoptions

Wraps [ko1nksm/getoptions](https://github.com/ko1nksm/getoptions) v3.3.0 as
a mush package. `getoptions` is a POSIX-compliant, zero-dependency option
parser for shell scripts.

mush itself uses `getoptions` internally to parse all CLI arguments.

## Installation

```toml
[dependencies]
getoptions = "mush getoptions"
```

## How it works

The package uses `[legacy-fetch]` to download the `getoptions` and
`gengetoptions` binaries from the official GitHub release, then
`[legacy-build]` to generate the embeddable library:

```toml
[legacy-fetch]
getoptions    = "file https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions"
gengetoptions = "file https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions"

[legacy-build]
getoptions = "gengetoptions library > __getoptions.sh"
```

The generated `__getoptions.sh` is then available via the `legacy getoptions`
directive in `src/lib.sh`.

## Usage

```bash
extern package getoptions

parser_definition() {
  setup REST help:usage -- "My tool"
  flag   VERBOSE -v --verbose -- "Enable verbose output"
  param  OUTPUT  -o --output  -- "Output file"
  disp   :usage  -h --help
}

main() {
  eval "$(getoptions parser_definition parse "$0")"
  parse "$@"
  eval "set -- $REST"
  # ...
}
```

## License

`getoptions` is distributed under the Creative Commons Zero v1.0 Universal
license by Koichi Nakashima. See the
[upstream repository](https://github.com/ko1nksm/getoptions) for details.
