#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/release/mush target/release/mush.test.sh
bash target/release/mush.test.sh build --release

echo "==> Test: install basic-plugin"
cd tests/fixtures/basic-plugin
rm -fr bin lib libexec share target
bash ../../../target/release/mush -vvvvvvvvv install --path .
../../../target/release/mush basic-plugin
