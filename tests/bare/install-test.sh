#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh -vv build --release
bash target/dist/mush --version

echo "==> Test: install error outside of a package directory"
mkdir -p tests/tmp
cd tests/tmp
bash ../../target/dist/mush install mush-demo
cd ../..

#echo "==> Test: install command"
#cd tests/fixtures/complex-app
#bash ../../../target/dist/mush install
#complex-app --version
#cd ../../..
