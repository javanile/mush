#!/usr/bin/env bash
set -e

cp target/dist/mush target/dist/mush.sh

bash target/dist/mush.sh --quiet build --target dist

cd tests/fixtures/basic-app

bash ../../../target/dist/mush run
