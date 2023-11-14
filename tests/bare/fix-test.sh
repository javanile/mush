#!/usr/bin/env bash
set -e

mkdir -p target/debug/ target/release/ && true

mush build --release
cp target/dist/mush target/debug/mush
cp target/dist/mush target/debug/mush.sh
cp target/dist/mush target/release/mush
cp target/dist/mush target/release/mush.sh
