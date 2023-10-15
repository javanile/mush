#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh -vv build --release

#echo "==> Test: getoptions"
cd packages/getoptions
bash ../../target/dist/mush build

#echo "==> Test: complex-app"
#cd tests/fixtures/complex-app
#bash ../../../target/dist/mush fetch
