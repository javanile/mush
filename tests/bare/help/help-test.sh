#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh -vv build --release

echo "==> Test: mush --help"
target/dist/mush --help
