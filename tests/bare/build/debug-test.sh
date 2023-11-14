#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build

echo "==> Build: basic-app"
cd tests/fixtures/basic-app
../../../target/debug/mush -vv build
