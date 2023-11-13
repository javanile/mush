#!/usr/bin/env bash
set -e

echo "==> Build Mush"
cp target/releasemush target/releasemush.sh
bash target/releasemush.sh build --target release
echo "==> Commit Changes"
git add .
git commit -am "Minor changes"
git push

echo "==> Publish Mush"
bash target/releasemush publish --allow-dirty
