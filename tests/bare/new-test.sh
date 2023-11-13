#!/usr/bin/env bash
set -e

cp target/releasemush target/releasemush.sh

bash target/releasemush.sh -vv build

mkdir -p tests/temp
cd tests/temp
rm -fr hello_world

bash ../../target/releasemush.sh -vv new hello_world

cd hello_world

cat Manifest.toml
