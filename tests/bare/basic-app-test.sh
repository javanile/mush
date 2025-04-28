#!/usr/bin/env bash
set -e

echo "Prepare system for testing..."
echo "------------------------------------------------------------------------------"

mush build -v --release
make install

echo ""
echo "Start testing basic-app..."
echo "------------------------------------------------------------------------------"

cd tests/fixtures/basic-app
rm -fr bin target
#mush build -vvvvvv
mush build -vvvvvv --release
./bin/basic-app
