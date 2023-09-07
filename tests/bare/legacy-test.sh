#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh -vv build

echo "==> Test: legacy"
cd tests/fixtures/zsh-app
bash ../../../target/dist/mush.sh legacy https://raw.githubusercontent.com/molovo/crash/master/crash
