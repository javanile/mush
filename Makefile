

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

test-usage-debug:
	@bash tests/bare/usage-debug-test.sh

test-rust:
	@cd tests/rust && cargo build