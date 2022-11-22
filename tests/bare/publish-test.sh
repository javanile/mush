#!/usr/bin/env bash
set -e

cp target/dist/mush target/dist/mush.sh

bash target/dist/mush.sh build --target dist

bash target/dist/mush.sh publish
