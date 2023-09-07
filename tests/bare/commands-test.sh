#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build
echo ""

echo "==> Test: build"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush.sh build
cd ../../..
echo ""

echo "==> Test: check"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush.sh check
cd ../../..
echo ""

echo "==> Test: init"
rm -fr tests/tmp/test-package && true
mkdir -p tests/tmp/test-package
cd tests/tmp/test-package
bash ../../../target/debug/mush.sh init
cd ../../..
echo ""

echo "==> Test: install"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush.sh install
cd ../../..
echo ""

echo "(done)"
