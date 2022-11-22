
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

test-install:
	@bash tests/bare/install-test.sh

test-run:
	@bash tests/bare/run-test.sh

test-new: build
	@bash tests/bare/new-test.sh

test-build-debug-basic-app:
	@bash tests/bare/build/debug-basic-app-test.sh

test-api-embed:
	@bash tests/bare/api/embed-test.sh

test-auto-build-debug-debug:
	@bash tests/bare/build/auto-debug-debug-test.sh

test-auto-build-debug-dist:
	@bash tests/bare/build/auto-debug-dist-test.sh

test-auto-build-dist-debug:
	@bash tests/bare/build/auto-dist-debug-test.sh

test-auto-build-dist-dist:
	@bash tests/bare/build/auto-dist-dist-test.sh

test-console:
	@bash tests/bare/console-test.sh

test-publish:
	@bash tests/bare/publish-test.sh

test-registry-github:
	@bash tests/bare/registry/github-test.sh
