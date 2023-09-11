#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh -vv build

## Test: docs
bash target/dist/mush --help | grep -A5000 "See" | tail -n+2 | while read line; do
  command=$(echo "$line" | awk '{print $1}')
  echo "==> Test: docs/$command"
  [ ! -f "docs/commands/mush-${command}.md" ] && echo "Error: docs/commands/mush-${command}.md not found" && exit 1
done


