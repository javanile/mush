#!/usr/bin/env bash
set -e

mush_bin="$PWD/target/dist/mush"

echo "==> Build: mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh -vv build

cd "$HOME"

echo "==> Test: install sysinfo with $mush_bin"

$mush_bin install sysinfo

sysinfo
