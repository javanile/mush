#!/usr/bin/env bash
set -e

FROM=dist
TO=debug

## Build Mush
cp target/${FROM}/mush target/${FROM}/mush.sh
bash target/${FROM}/mush.sh build --target ${TO}
bash target/${TO}/mush --version
