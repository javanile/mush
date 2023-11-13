#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh build --release

echo "==> Test: complex-app"
cd tests/fixtures/complex-app
rm -fr bin lib libexec share target
bash ../../../target/releasemush -vvvvvvvvv build
