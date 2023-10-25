#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh -vv build --release
bash target/dist/mush --version

echo "==> Test: print"
cd tests/fixtures/complex-app
bash ../../../target/dist/mush --print cavallo
