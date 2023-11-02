#!/usr/bin/env bash
test_errors_E0463_build() { assert_equals "$(cat tests/ui/errors/E0463/build.out)" "$(cat tests/ui/errors/E0463/build.out.0)"; }
