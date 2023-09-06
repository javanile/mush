#!/usr/bin/env bash
set -e

for from in debug dist; do
  for to in debug dist; do
    echo "Building from '${from}' to '${to}'..."
    echo "------------------------------------------------------------"
    cp "target/${from}/mush" "target/${from}/mush.sh"
    bash "target/${from}/mush.sh" build --target "${to}"
    bash "target/${to}/mush" --version
    echo "(done)"
    echo ""
  done
done
