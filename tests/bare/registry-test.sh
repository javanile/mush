#!/usr/bin/env bash
set -e

## Build Mush
#cp target/debug/mush target/debug/mush.sh
#sh target/debug/mush.sh build

## Build Basic App
cd tests/fixtures/empty-dir
rm -fr target lib && true
rm -fr $HOME/.mush/registry/index && true
sh -x ../../../target/debug/mush -vvv install demo && true
sh ../../../target/debug/mush -vvv install demo && true
cat $HOME/.mush/registry/index/https-github-com-javanile-mush.cache