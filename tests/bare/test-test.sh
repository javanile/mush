#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build
echo ""

echo "==> Build: empty-app"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush -vv test main
