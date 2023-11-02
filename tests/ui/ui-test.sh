#!/usr/bin/env bash
test_error_E0463_build() { assert_equals "$(cat tests/fixtures/ui/error/E0463/build.out)" "$(cat tests/fixtures/ui/error/E0463/build.out.0)"; }
test_error_manifest_not_found_build() { assert_equals "$(cat tests/fixtures/ui/error/manifest-not-found/build.out)" "$(cat tests/fixtures/ui/error/manifest-not-found/build.out.0)"; }
test_command_mush_help() { assert_equals "$(cat tests/fixtures/ui/command/mush/help.out)" "$(cat tests/fixtures/ui/command/mush/help.out.0)"; }
test_command_mush_version() { assert_equals "$(cat tests/fixtures/ui/command/mush/version.out)" "$(cat tests/fixtures/ui/command/mush/version.out.0)"; }
test_command_publish_publish() { assert_equals "$(cat tests/fixtures/ui/command/publish/publish.out)" "$(cat tests/fixtures/ui/command/publish/publish.out.0)"; }
test_command_publish_help() { assert_equals "$(cat tests/fixtures/ui/command/publish/help.out)" "$(cat tests/fixtures/ui/command/publish/help.out.0)"; }
