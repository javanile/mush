#!/usr/bin/env bash
test_tures_ui_error_E0463_build() { assert_equals "$(cat tests/fixtures/ui/error/E0463/build.out)" "$(cat tests/fixtures/ui/error/E0463/build.out.0)"; }
test_tures_ui_error_manifest_not_found_build() { assert_equals "$(cat tests/fixtures/ui/error/manifest-not-found/build.out)" "$(cat tests/fixtures/ui/error/manifest-not-found/build.out.0)"; }
