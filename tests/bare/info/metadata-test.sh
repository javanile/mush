#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/release/mush target/release/mush.test.sh
bash target/release/mush.test.sh -vv build --release

echo "==> Test: mush metadata"
cd tests/fixtures/basic-app
../../../target/release/mush metadata
