#!/usr/bin/env bash
set -e

cp target/releasemush target/releasemush.sh
bash target/releasemush.sh -vv build

mkdir -p tests/tmp/init-test
cd tests/tmp/init-test
rm -fr Manifest.toml

bash ../../../target/releasemush.sh -vv init

cat Manifest.toml
