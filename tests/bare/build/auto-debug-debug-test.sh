#!/usr/bin/env bash
set -e

profile_from=debug
profile_to=debug

## Build Mush
rm -fr "${PWD}/.mush" && true
cp target/${profile_from}/mush target/${profile_from}/mush.sh
MUSH_HOME=${PWD}/.mush bash target/${profile_from}/mush.sh build
bash target/${profile_to}/mush --version
