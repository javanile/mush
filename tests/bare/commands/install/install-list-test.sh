#!/usr/bin/env bash
set -e

## Build Mush
echo "====[ Build: Mush ]======================================================="
cp target/debug/mush target/debug/mush.sh
sh target/debug/mush.sh build

## Build Basic App
echo "====[ Test: Install List ]======================================================="
rm -fr "$HOME/.mush/registry/"
sh target/debug/mush -vvvv install console
sh target/debug/mush install --list
