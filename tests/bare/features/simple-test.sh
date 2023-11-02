#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh build --release

echo "==> Test: complex-app"
cd tests/fixtures/complex-app
rm -fr bin lib libexec share target
bash ../../../target/dist/mush -vvvvvvvvv build
