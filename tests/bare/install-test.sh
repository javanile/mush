#!/usr/bin/env bash
set -e

cp target/dist/mush target/dist/mush.sh

bash target/dist/mush.sh -vv install

mush --version
