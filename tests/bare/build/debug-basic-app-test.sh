#!/usr/bin/env bash
set -e

## Build Mush
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build

## Build Basic App
cd tests/fixtures/basic-app
rm -fr target lib && true
bash ../../../target/debug/mush -vvv build
