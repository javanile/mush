#!/usr/bin/env bash
set -e

## Build Mush
cp target/debug/mush target/debug/mush.sh
sh target/debug/mush.sh build

## Build Basic App
rm -fr "$HOME/.mush/registry/"
sh target/debug/mush -vvv search http
