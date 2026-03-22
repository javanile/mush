#!/usr/bin/env bash
set -e

## Build Mush
echo "====[ Build: mush ]======================================================="
cp target/release/mush target/release/mush.test.sh
bash target/release/mush.test.sh build --release

## Test: mush add name_convention@develop --dev
echo "====[ Test: mush add name_convention@develop --dev ]======================"
cd tests/fixtures/mush-name-convention

## Clean previous state: remove target, lib, and the entire [dev-dependencies] section
## Keep [features] with name_convention = true to verify add does not touch it
rm -fr target lib
awk 'BEGIN{s=0} /^\[dev-dependencies\]/{s=1;next} /^\[/{s=0} !s' Manifest.toml > Manifest.toml.tmp && mv Manifest.toml.tmp Manifest.toml
grep -q '^name_convention = true' Manifest.toml  ## pre-condition: feature flag must exist

## Run mush add as a human would
bash ../../../target/release/mush add name_convention@develop --dev

## Verify the plugin is listed in Manifest.toml under [dev-dependencies]
grep -q '^\[dev-dependencies\]' Manifest.toml
grep -q '^name_convention = ' Manifest.toml

## Verify [features] name_convention = true was not touched
grep -q '^name_convention = true' Manifest.toml

## Verify the plugin files are present in the expected locations
test -f lib/name_convention
test -f target/release/plugins/name_convention/plugin.sh
test -f target/release/packages/name_convention/lib.sh

echo "====[ OK ]================================================================"