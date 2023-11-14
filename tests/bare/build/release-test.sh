#!/usr/bin/env bash
set -e

cp target/releasemush target/releasemush.sh

bash target/releasemush.sh -vv build --target release
./bin/mush --version

mkdir -p tests/temp
cd tests/temp

bash ../../target/releasemush.sh -vv build
