# test_with_bashunit

Integrates the [bashunit](https://github.com/TypedDevs/bashunit) testing
framework into mush packages via the legacy dependency system.

## Installation

```toml
[dependencies]
test_with_bashunit = "mush test_with_bashunit"
```

## How it works

The package uses `[legacy-fetch]` to clone bashunit from GitHub:

```toml
[legacy-fetch]
bashunit = "git https://github.com/TypedDevs/bashunit.git"
```

`src/lib.sh` then exposes all bashunit modules via `legacy` directives,
making the full assertion API available in your tests:

```bash
legacy bashunit::assert
legacy bashunit::assert_arrays
legacy bashunit::assert_files
# ...and more
```

## Usage

```toml
[dev-dependencies]
test_with_bashunit = "mush test_with_bashunit"
```

```bash
extern package test_with_bashunit

test_addition() {
  assert_equals 4 $((2 + 2))
}

test_string() {
  assert_equals "hello" "hello"
}
```

Run your tests with:

```bash
mush test
```

## Available assertion modules

| Module | Purpose |
|--------|---------|
| `assert` | Basic value assertions |
| `assert_arrays` | Array equality and membership |
| `assert_files` | File existence and content |
| `assert_folders` | Directory checks |
| `assertions` | Assertion core |
| `helpers` | Test helper utilities |
| `runner` | Test runner |
| `state` | Test state management |
| `colors` | Terminal color output |
| `console_header` | Test suite header |
| `console_results` | Results summary |
| `check_os` | OS detection helpers |
| `env_configuration` | Environment setup |
| `skip_todo` | Skip and todo markers |
| `test_doubles` | Mocks and stubs |

## License

bashunit is maintained by [TypedDevs](https://github.com/TypedDevs/bashunit)
under its own license. This wrapper package is part of the mush project.
