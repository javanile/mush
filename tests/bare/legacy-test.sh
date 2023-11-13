#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh -vv build

echo "==> Test: legacy"
cd tests/fixtures/zsh-app
bash ../../../target/releasemush.sh legacy https://raw.githubusercontent.com/molovo/crash/master/crash
