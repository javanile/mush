#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build
echo ""

echo "==> Build: basic-app (from debug)"
cd packages/getoptions
rm -fr target lib && true
bash ../../target/debug/mush -vvvvvvv build
