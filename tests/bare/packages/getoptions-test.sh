#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh -vv build --release

#echo "==> Test: getoptions"
cd packages/getoptions
bash ../../target/releasemush build

#echo "==> Test: complex-app"
#cd tests/fixtures/complex-app
#bash ../../../target/releasemush fetch
