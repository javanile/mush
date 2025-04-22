# Mush - Shell Package Builder

## Build Commands
- **Build in debug mode:** `make build` or `mush build`
- **Build in release mode:** `make release` or `mush build --release`
- **Run linting:** `make shellcheck` or manually with `shellcheck -e SC2148,SC2155,SC2034 src/**/*.sh`
- **Run a specific test:** `bash tests/bare/[test-name].sh` or `make test-[feature-name]`
- **Run multiple tests:** Check Makefile for grouped test targets (like `test-build-debug`)

## Code Style Guidelines
- **Naming:** Use snake_case for functions, UPPER_CASE for global variables
- **Modules:** Each module has a `module.sh` file; use `module [name]` to include
- **Dependencies:** Declare with `extern package [name]`
- **Public functions:** Mark with `public` keyword in module files
- **Error handling:** Use centralized error functions from `src/errors/module.sh`
- **Comments:** Minimal but descriptive, focusing on "why" not "what"

## Project Organization
- Shell scripts organized in modules
- Executable commands in `src/commands/`
- Testing done with BashUnit in `tests/` directory
- Error codes follow Rust-like naming (E0463, E0583, etc.)

## Testing Strategy
- Test files named with `-test.sh` suffix
- Run tests through `make test-*` targets
- Add new tests in `tests/bare/` directory