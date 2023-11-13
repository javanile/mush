#!/usr/bin/env bash
set -e

mush_bin="$PWD/target/releasemush"

echo "==> Build: mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh -vv build

cd "$HOME"

echo "==> Test: install sysinfo with $mush_bin"

$mush_bin install sysinfo

sysinfo
