#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh -vv build --release
bash target/releasemush --version

echo "==> Test: install error outside of a package directory"
mkdir -p tests/tmp
cd tests/tmp
bash ../../target/releasemush install mush-demo
cd ../..

#echo "==> Test: install command"
#cd tests/fixtures/complex-app
#bash ../../../target/releasemush install
#complex-app --version
#cd ../../..
