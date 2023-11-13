#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/release/mush target/release/mush.sh
bash target/release/mush.sh build --release

echo "==> Test: basic-app"
cd tests/fixtures/basic-app
rm -fr bin lib libexec share target my_target_1 my_target_2 && true
../../../target/release/mush run --example demo
