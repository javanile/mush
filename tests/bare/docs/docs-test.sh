#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh -vv build

## Test: docs
bash target/releasemush --help | grep -A5000 "See" | tail -n+2 | while read line; do
  command=$(echo "$line" | awk '{print $1}')
  echo "==> Test: docs/$command"
  [ ! -f "docs/commands/mush-${command}.md" ] && echo "Error: docs/commands/mush-${command}.md not found" && exit 1
done


