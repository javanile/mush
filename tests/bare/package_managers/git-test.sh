#!/usr/bin/env bash
set -e

## Build Mush
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build --target debug
bash target/debug/mush build -v --target release
## Build Complex App
cd tests/fixtures/complex-app
bash ../../../target/releasemush build -v --target debug
