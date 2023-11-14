#!/usr/bin/env bash
set -e

profile_from=debug
profile_to=debug

## Build Mush
cp target/${profile_from}/mush target/${profile_from}/mush.sh
MUSH_HOME=${PWD} bash target/${profile_from}/mush.sh build
bash target/${profile_to}/mush --version
