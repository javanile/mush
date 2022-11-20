#!/usr/bin/env bash
set -e

FROM=debug
TO=debug

## Build Mush
cp target/${FROM}/mush target/${FROM}/mush.sh
bash target/${FROM}/mush.sh build --target ${TO}
bash target/${TO}/mush --version
