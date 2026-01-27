#!/usr/bin/env bash
set -e

cp target/release/mush target/release/mush.sh
bash target/release/mush.sh -vv build --release

mkdir -p tests/tmp/init-test
cd tests/tmp/init-test
rm -fr Manifest.toml

bash ../../../target/release/mush -vv init

tree .
cat Manifest.toml
