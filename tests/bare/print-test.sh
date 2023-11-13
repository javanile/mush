#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh -vv build --release
bash target/releasemush --version

echo "==> Test: print"
cd tests/fixtures/complex-app
bash ../../../target/releasemush --print b
