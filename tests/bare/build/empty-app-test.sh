#!/usr/bin/env bash
set -e

echo "==> Build Mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build --target debug

echo "==> Build Fixtures"
cd tests/fixtures/empty-app
bash ../../../target/debug/mush -vv build
