#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh -vv build --release

#echo "==> Test: bashunit"
cd packages/test_with_bashunit
bash ../../target/releasemush build

#echo "==> Test: complex-app"
#cd tests/fixtures/complex-app
#bash ../../../target/releasemush fetch
