#!/usr/bin/env bash

cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build --target dist

cd tests/fixtures/basic-app

bash ../../../target/dist/mush.sh --vv build --target debug
