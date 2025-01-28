#!/usr/bin/env bash
set -e

## Build Mush
echo "====[ Build: Mush ]======================================================="
cp target/debug/mush target/debug/mush.sh
sh target/debug/mush.sh build

## Build Basic App
echo "====[ Test: Search ]======================================================="
#rm -fr "$HOME/.mush/registry/"
sh target/debug/mush search amazing
