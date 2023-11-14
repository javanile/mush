#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/release/mush target/release/mush.sh
bash target/release/mush.sh build -vvvvvvvvv --release

echo "==> Test: basic-app"
cd tests/fixtures/basic-app
rm -fr bin lib libexec share target my_target_1 my_target_2 && true
MUSH_TARGET_DIR=my_target_1 bash ../../../target/release/mush -vvvvvvvvv build
MUSH_TARGET_DIR=my_target_2 bash ../../../target/release/mush -vvvvvvvvv build --release

echo "==[ Files ]=="
tree .
