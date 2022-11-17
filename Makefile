
## ===
## Dev
## ===

build:
	@mush build

## ====
## Test
## ====

test-legacy-fetch-debug:
	@bash tests/bare/legacy/debug-fetch-test.sh

test-build-debug:
	@bash tests/bare/build/debug-test.sh

test-build-dist:
	@bash tests/bare/build/dist-test.sh

test-task-build-dist:
	@bash tests/bare/tasks/build-dist-test.sh

test-task-manifest-lookup:
	@bash tests/bare/tasks/manifest-lookup-test.sh

test-usage-debug:
	@bash tests/bare/usage-debug-test.sh

test-rust:
	@cd tests/rust && cargo build

test-init: build
	@bash tests/bare/init-test.sh

test-install: build
	@bash tests/bare/install-test.sh

test-run: build
	@bash tests/bare/run-test.sh

test-new: build
	@bash tests/bare/new-test.sh
