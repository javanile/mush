#!/usr/bin/env bash
set -e

## Build Mush
rm target/debug/mush
mush build
cp target/debug/mush target/debug/mush.sh
sh target/debug/mush.sh build
exit

## Build Basic App
cd tests/fixtures/basic-app
rm -fr target lib && true
bash ../../../target/debug/mush -vvv install demo
bash ../../../target/debug/mush -vvv install demo
