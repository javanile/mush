#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build

echo "==> Build: empty-app"
cd tests/fixtures/empty-app
bash ../../../target/debug/mush -vv build
