#!/usr/bin/env bash
set -e

cp target/dist/mush target/dist/mush.sh

bash target/dist/mush.sh -vv build

mkdir -p tests/temp
cd tests/temp
rm -fr hello_world

bash ../../target/dist/mush.sh -vv new hello_world

cd hello_world

cat Manifest.toml
