#!/usr/bin/env bash
set -e

## Build Mush
#cp target/debug/mush target/debug/mush.sh
#sh target/debug/mush.sh build

## Build Basic App
cd tests/fixtures/empty-dir
rm -fr target lib && true
sh -x ../../../target/debug/mush -vvv install demo
#bash ../../../target/debug/mush -vvv install demo
