#!/usr/bin/env bash

echo "==> Build Mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build --target dist

echo "==> Build Fixtures"
cd tests/fixtures/basic-app
bash -x ../../../target/debug/mush.sh --vv build --target debug
