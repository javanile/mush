#!/usr/bin/env bash
set -e

## Build Mush
echo "====[ Build: mush ]======================================================="
cp target/release/mush target/release/mush.test.sh
bash target/release/mush.test.sh build --release

## Test: mush add name_convention@develop --dev
echo "====[ Test: mush add name_convention@develop --dev ]======================"
cd tests/fixtures/mush-name-convention

## Clean previous state
rm -fr target lib
sed -i '/^name_convention/d' Manifest.toml

## Run mush add as a human would
bash ../../../target/release/mush add name_convention@develop --dev

## Verify the plugin is listed in Manifest.toml under [dev-dependencies]
grep -q 'name_convention' Manifest.toml

## Verify the plugin files are present in the expected locations
test -f lib/name_convention
test -f target/release/plugins/name_convention/plugin.sh
test -f target/release/packages/name_convention/lib.sh

echo "====[ OK ]================================================================"