#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build
echo ""

echo "==> Build: basic-app (from debug)"
cd tests/fixtures/basic-app
rm -fr target lib && true
bash ../../../target/debug/mush -vvvvvvv build
bash ../../../target/debug/mush -vvvvvvv run
