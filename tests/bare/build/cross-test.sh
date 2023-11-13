#!/usr/bin/env bash
set -e

for from in debug release; do
  for to in debug release; do
    echo "Building from '${from}' to '${to}'..."
    echo "------------------------------------------------------------"
    cp "target/${from}/mush" "target/${from}/mush.sh"
    if [ "${to}" = "release" ]; then
        bash "target/${from}/mush.sh" build --release
    else
        bash "target/${from}/mush.sh" build
    fi
    bash "target/${to}/mush" --version
    echo "(done)"
    echo ""
  done
done
