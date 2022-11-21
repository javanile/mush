#!/usr/bin/env bash
set -e

cp target/dist/mush target/dist/mush.sh

bash target/dist/mush.sh build

cd tests/fixtures/basic-app

bash ../../../target/dist/mush.sh -vv run
