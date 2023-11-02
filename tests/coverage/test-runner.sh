#!/usr/bin/env bash
set -e

cp ./tests/coverage/.shellspec .shellspec
./lib/shellspec/shellspec tests/coverage/coverage_spec.sh
rm .shellspec
